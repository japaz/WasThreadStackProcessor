# encoding: utf-8

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :xzibit, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "WasThreadStackProcessor"
  gem.homepage = "http://github.com/japaz/WasThreadStackProcessor"
  gem.license = "MIT"
  gem.summary = %Q{Utility to process Thread Stacks from a WebSphere Application Server}
  gem.description = %Q{This utility extracts all the Thread Stacks from a set of thread dump files of a WebSphere Application Server and generates a unique tree with all the threads}
  gem.email = "alberto.pazjimenez@gmail.com"
  gem.authors = ["Alberto Paz"]
  # dependencies defined in Gemfile
end

Jeweler::RubygemsDotOrgTasks.new


require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :rspec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "WasThreadStackProcessor #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

if ENV["RUN_CODE_RUN"] == "true"
  task :default => [:test, :features]
else
  task :default => :test
end
