namespace :shapefiles_113 do

  desc 'Downloads shapefiles to db/2013/zips from Census redistricting office'
  # See: https://www.census.gov/rdo/data/113th_congressional_and_new_state_legislative_district_plans.html
  #
  # Zip files include numerous unneeded mapping files (waterways info), but the files we need don't seem to be provided any other way.
  # In addition to shape files, these zips include *.shx, *.dbf, *.prj, *.shp, *.shx
  #
  # INTERNAL NOTE: We have a copy of the needed files on dev.mcommons.com/home/rails/archive/redistricting_data_113_congress.sql.bz2
  task :download => :environment do
    District::FIPS_CODES.keys.sort.each do |fips_code|
      p "Downloading #{fips_code}"
      `mkdir -p db/2013/zips`
      `wget ftp://ftp2.census.gov/geo/pvs/#{fips_code}/partnership_shapefiles_12v2_#{fips_code}.zip -nc -c --directory-prefix=db/2013/zips`
    end
  end

  desc 'Unzips relevant files to db/2013/shapes'
  task :unzip => :environment do
    p 'Unzipping relevant files to db/2013/shapes'
    `mkdir db/2013/shapes`
    `rm db/2013/shapes/*`
    file_extensions = %w(shp dbf shx)
    District::FIPS_CODES.keys.sort.each do |fips_code|
      state_files_to_extract = []
      %w(sldl sldu).each do |file_type|
        state_files_to_extract += file_extensions.collect{|file_ext| "PVS_12_v2_#{file_type}_#{fips_code}.#{file_ext}" }
      end
      `unzip db/2013/zips/partnership_shapefiles_12v2_#{fips_code}.zip #{state_files_to_extract.join(' ')} -d db/2013/shapes/`

      cd_files_to_extract = file_extensions.collect{|file_ext| "PVS_12_v2_cd_#{fips_code}.#{file_ext}"}
      `unzip db/2013/zips/partnership_shapefiles_12v2_#{fips_code}.zip #{cd_files_to_extract.join(' ')} -d db/2013/shapes/`
    end
  end

  task :convert_to_sql => :environment do
    p 'converting shape files into sql_files'
    `mkdir db/2013/sql`
    `rm db/2013/sql/*`
    cmd = 'c -I' # the first run should do Create statements and add Indexes
    District::FIPS_CODES.keys.sort.each do |fips_code|
      first_shp_name = "db/2013/shapes/PVS_12_v2_sldl_#{fips_code}.shp"
      if File.exist?(first_shp_name)
        p "processing #{fips_code}"
        `shp2pgsql -#{cmd} db/2013/shapes/PVS_12_v2_sldl_#{fips_code}.shp temp_lower > db/2013/sql/state_lower_#{fips_code}.sql`
        `shp2pgsql -#{cmd} db/2013/shapes/PVS_12_v2_sldu_#{fips_code}.shp temp_upper > db/2013/sql/state_upper_#{fips_code}.sql`
        `shp2pgsql -#{cmd} db/2013/shapes/PVS_12_v2_cd_#{fips_code}.shp temp_federal > db/2013/sql/federal_#{fips_code}.sql`
        cmd = 'a' # subsequent runs should do Appends
      end
    end
  end

  desc 'Wrapper: Download and convert shapefiles to pgsql. (wraps :download, :unzip, :convert_to_sql)'
  task :prep_sql_files => [:download, :unzip, :convert_to_sql]

  desc 'Import raw sql files that were generated from shp2pgsql in prep_sql_files task.'
  task :import_sql => :environment do
    p 'importing raw sql files that were generated from shp2pgsql'

    connection = ActiveRecord::Base.connection
    connection.drop_table(:temp_federal) if connection.table_exists?(:temp_federal)
    connection.drop_table(:temp_lower) if connection.table_exists?(:temp_lower)
    connection.drop_table(:temp_upper) if connection.table_exists?(:temp_upper)

    config = Rails::Configuration.new
    host   = config.database_configuration[RAILS_ENV]["host"]
    db     = config.database_configuration[RAILS_ENV]["database"]
    user   = config.database_configuration[RAILS_ENV]["username"]

    ##Import raw data into temp_lower and temp_upper
    file_path = "#{RAILS_ROOT}/db/2013/sql"
    District::FIPS_CODES.keys.sort.each do |fips_code| # sort sdisplay_nameo sql with CREATEs run first
      %W(lower upper).each do |level_name|
        file_name = "#{file_path}/state_#{level_name}_#{fips_code}.sql"
        if File.exist?(file_name)
          p "processing #{file_name}"
          `psql -h #{host} -d #{db} -f #{file_name} -U #{user}`
        end
      end
      cd_file_name = "#{file_path}/federal_#{fips_code}.sql"
      if File.exist?(cd_file_name)
        p "processing #{cd_file_name}"
        `psql -h #{host} -d #{db} -f #{cd_file_name} -U #{user}`
      end
    end
  end

  desc 'Move federal level data into temp_districts table.'
  task :federal_data_to_temp => :environment do
    p 'Moving federal level data into temp_districts table.'
    #districts table field name:imported field name
    #
    #state:statefp
    #cd:sldlst|sldust|cdfp
    #name:name (the namelsad field pretty well matches too but has more words in it which is less good for our app)
    #the_geom:the_geom
    #level:manually filled in

    ActiveRecord::Base.transaction do
      connection = ActiveRecord::Base.connection

      %w(chng_type eff_date lsad namelsad new_code reltype1 reltype2 reltype3 reltype4 reltype5 rel_ent1 rel_ent2 rel_ent3 rel_ent4 rel_ent5 relate cdsessn vintage funcstat cdtyp).each do |column_name|
        connection.remove_column :temp_federal, column_name
      end

      {:state => 'statefp',:cd => 'cdfp'}.each do |system_name,imported_name|
        connection.rename_column :temp_federal, imported_name, system_name
      end

      connection.add_column :temp_federal, :level, :string
      connection.change_column :temp_federal, :cd, :string, :limit => 3
      connection.execute "UPDATE temp_federal SET level = 'federal'"

      connection.drop_table(:temp_districts) if connection.table_exists?(:temp_districts)
      connection.execute "ALTER TABLE temp_federal RENAME TO temp_districts"
    end
  end

  desc 'Move state level data into temp_districts table.'
  task :state_data_to_temp => :environment do
    p 'Moving state level data into temp_districts table.'
    connection = ActiveRecord::Base.connection

    %W(lower upper).each do |level_name|
      p "inserting temp_#{level_name} into temp_districts"
      connection.execute(
        "INSERT INTO temp_districts (state,   cd,                        name, the_geom, level)
         SELECT                      statefp, sld#{level_name[0,1]}st,   name, the_geom, 'state_#{level_name}'
         FROM temp_#{level_name}")
    end
  end

  desc 'Various scripts to help normalize temp_district data.'
  task :normalize_temp_districts_names => :environment do
    # There are some differences in district names between the new 113th congress data from census.gov, and what we're
    # getting from votesmart. Since we know we're getting 112th congress data from votesmart, we're going to ignore
    # these differences for now. Once we start getting new data from them, we'll check the differences again#
    # (mcommons, rake one_off:test_tigress_data) and add any needed data fixes.

    # Remove from mcommons platform: state 25 lower:
    #   Seventh Middlesex
    #   Nineteenth Middlesex District
    #   Barnstable, Dukes & Nantucket District
    #   Middlesex & Essex
    #   Third Essex & Middlesex
    #   Middlesex, Suffolk & Essex District
    #   Suffolk & Norfolk
    #   Norfolk, Bristol & Plymouth District
    #   Hampshire & Franklin
    #   Berkshire, Hampshire & Franklin District
    #   Worcester, Hampden, Hampshire & Franklin District
    #   Norfolk, Bristol & Middlesex District

    # 50 lower a few names missing '-1'. Eg: "Grand Isle-Chittenden" (new data) or "Grand Isle-Chittenden-1-1" (http://votesmart.org/officials/VT/L/vermont-state-legislative#.UNiU0m_O2BU)

    # puts "21st to Twenty-First"
    # class TempDistrict < District
    #   set_table_name "temp_districts"
    # end
    # TempDistrict.all(:conditions=>["state = '25' and level = 'state_lower' and name ~ '^[0-9]'"]).each do |district|
    #   district.update_attributes(:name => numbers_to_words(district.name))
    # end

    # puts "Rename Grand-Isle... to Grand Isle..."
    # connection.execute "update temp_districts set name = replace(name, 'Grand-Isle', 'Grand Isle') where state = '50' and name ~ 'Grand Isle'"

    connection = ActiveRecord::Base.connection

    puts "Remove roman numerals"
    %w(I II III IV V VI VII VIII).each_with_index do |numeral, index|
      connection.execute "update temp_districts set name = #{index + 1} where name = '#{numeral}'"
    end

    puts "Set most at large districts to 1"
    connection.execute "update temp_districts set name = '98' where state = '72' and level = 'federal'" # naming it 98 because that's how it was before the 113 congress update
    connection.execute "update temp_districts set name = '1' where level = 'federal' and name ~* 'at large'"

    puts "Remove 'County No. ' from NH state levels"
    connection.execute "update temp_districts set name = replace(name, 'County No. ', '') where state = '33' and level like 'state_%'"

    puts "Remove 'HD-' from district names for SC state lower"
    connection.execute "update temp_districts set name = replace(name, 'HD-', '') where state = '45' and level = 'state_lower'"

    # TODO once this is live, remove the trim_leading_zeros() calls from Location.
    puts "Trim leading zeros from state district names"
    connection.execute "update temp_districts set name = regexp_replace(name, '^0+', '') where level like 'state_%' and name ~ '^0+'"
  end

  desc 'Replace data in districts table with the new data from temp_districts.'
  task :temp_to_live => :environment do
    puts "Replacing live table with newly imported data"
    ActiveRecord::Base.transaction do
      connection = ActiveRecord::Base.connection
      connection.execute "DROP TABLE districts"
      connection.execute "ALTER TABLE temp_districts RENAME TO districts"
    end
  end

  desc 'Drop temp tables, if they still exist.'
  task :drop_temp_tables => :environment do
    puts 'Dropping temp tables'
    connection = ActiveRecord::Base.connection

    connection.drop_table(:temp_districts) if connection.table_exists?(:temp_districts)
    connection.drop_table(:temp_lower) if connection.table_exists?(:temp_lower)
    connection.drop_table(:temp_upper) if connection.table_exists?(:temp_upper)
  end

  desc 'Wrapper: command that handles full import process DESTROYING and ALTERING districts table.'
  task :import => [:import_sql, :federal_data_to_temp, :state_data_to_temp, :normalize_temp_districts_names, :temp_to_live, :drop_temp_tables]

end
