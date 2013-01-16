# Project Tigress

## Description

Rails application and database to lookup congressional and state legislative districts by latitude and longitude.

## Installation

Install Postgres and postGIS, set up a database, apply the appropriate functions and populate it.


### Ubuntu 11.04 Start

Install Postgress

    sudo apt-get install postgresql-contrib postgresql postgresql-9.1-postgis libpq-dev

Postgres won't let you connect without a password out of the box. Create a new postgres user with a password or configure postgres to trust all connections from localhost and make sure the "postgres" user in postgres doesn't have a password. These instruction assume the later. You can do that by editing `/etc/postgresql/8.4/main/pg_hba.conf` and adding a line ABOVE THE DEFAULT RULES like this:

    host    all         postgres    127.0.0.1/32          trust

After you create your database you need to add required functions to your database. Note: You'll need to do the same for your test database.

    DB="congress_development" # or whatever you want to call it
    sudo -u postgres createdb -E UTF8 $DB
    createlang -h localhost -U postgres plpgsql $DB
    DB="congress_test"
    psql -h localhost -U postgres -d $DB -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql
    psql -h localhost -U postgres -d $DB -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql
    psql -h localhost -U postgres -d $DB -c "select postgis_lib_version();" # to make sure postgis works

### OSX 10.7 Start

Download postgres.app from http://postgresapp.com/.
Extract it.
Copy it to Applications.

    $ sudo cp /Applications/Postgres.app/Contents/MacOS/lib/libjpeg* /usr/local/lib # to make postgis work with postgres.app
Run
 postgres.app.

    $ DB="congress_development"
    $ psql -h localhost -c "CREATE DATABASE $DB;"
    $ psql -h localhost -d $DB -c "CREATE EXTENSION postgis;"


### Common Finish: Ruby Environment

    gem update --system 1.3.7 # rails 2.2 doesn't completely work with new versions of rubygems. eg: 'rake gems:refresh_specs' will fail with rubygems 1.5.2
    gem install postgres -v '0.7.9.2008.01.28' # this is what's used in production
    gem install rdoc
    gem install rspec -v 1.3.2
    gem install rspec-rails -v 1.3.4
    ./script/server

Visit http://localhost:3000/. The page should load although nothing will work yet because there's no data in the database. Run the following to load the full collection of shape files from census

    rake db:migrate
    rake shapefiles_113:prep_sql_files # Downloads files from census, unzip those files and convert with shp2pgsql.
    rake shapefiles_113:import # Import sql files into temp tables, normalize naming converions and load into districts table.

## Testing

To run specs, you need to seed the database with sample polygons.  This repo contains sql imports for RI. To execute run:

    rake db:test:prepare
    rake spec

## Updating Data

District data is imported using the code in `lib/tasks/shapefile_procssing.rake`. Run `rake -T shapefiles_113` from terminal to view the available tasks.  Those tasks execute the basic process for updating district data, as outlined below.

1. Download the relevant zipped shape files with the new data - from the [U.S. Census](https://www.census.gov/rdo/data/113th_congressional_and_new_state_legislative_district_plans.html).
2. Unzip the shape files.
3. Use shp2pgsql to convert the shape files to sql that will put it in temporary tables.
4. Execute that sql for federal and then state data.
5. Normalize the data in the temp tables.
6. Copy the temporary data into the final `districts` table.
7. Delete the temporary tables.

The above steps have been completed for [http://congress.mcommons.org](http://congress.mcommons.org). Please review the tasks and code in `lib/tasks/shapefile_procssing.rake`



## Authors

 - [Nathan Woodhull](mailto:nathan@mcommons.com)
 - [Benjamin Stein](mailto:ben@mcommons.com)
 - [Mal McKay](mailto:mal@mcommons.com)
 - [Mario Olivio Flores](mailto:mflores3@gmail.com)
 - [Dan Benamy](mailto:dbenamy@mcommons.com)

Project sponsored by [Mobile Commons](http://www.mobilecommons.com/)


## License

Copyright (c) 2008-2012 Mobile Commons
See MIT-LICENSE in this directory.
