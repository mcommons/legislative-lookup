# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
#require 'spec/rake/spectask'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

#require 'rspec/core/rake_task'
# require File.expand_path('../../config/environment', __FILE__)
# require 'rspec/rails'
# require 'rspec/autorun'

Spec::Runner.configure do |config|
#RSpec.configure do |config|
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
end
