set :application,         "congress"
set :user,                "deploy"
set :runner,              "deploy"
set :scm,                 "git"
set :repository_host,     "dev.mcommons.com"
set :repository,          "#{user}@#{repository_host}:/repos/ligerhorn.git"
set :temp_deployment_dir, "/tmp/mcommons_deploy"
set :deploy_to,           "/apps/congress"
set :repository_cache,    "cached-copy"
set :checked_out_repo,    "#{deploy_to}/shared/#{repository_cache}"
set :monit,               "/usr/bin/monit"



set :campfire_subdomain,  "mcommons"
set :campfire_ssl,        true
set :campfire_email,      "mse-6@mcommons.com"
set :campfire_password,   "Rebaxan"
set :campfire_room,       "Mobile Commons"

set :ssh_options,  { :paranoid => false, :port => 7822 }

depend :remote, :gem,     "mongrel",                ">=1.0.1",    :roles => :app
depend :remote, :gem,     "mongrel_cluster",        ">=1.0.1.1",  :roles => :app
depend :remote, :gem,     "postgres",               ">=0.7",      :roles => :app

role :app, "congress.mcommons.com"
role :web, "congress.mcommons.com"
role :db,  "congress.mcommons.com", :primary => true

 
namespace :deploy do

  desc "Deploy and start the app servers"
  task :cold do
    update
    start
  end
  
  desc "Start Mongrel processes on the app server."
  task :start , :roles => :app do
    sudo "#{monit} -g mongrel start all"
  end

  desc "Restart the Mongrel processes on the app server by starting and stopping the cluster."
  task :restart , :roles => :app do
    sudo "#{monit} -g mongrel restart all"
  end

  desc "Stop the Mongrel processes on the app server."
  task :stop , :roles => :app do
    sudo "#{monit} -g mongrel stop all"
  end
end

