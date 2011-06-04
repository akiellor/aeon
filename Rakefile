require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'rake/aeon_store'

desc 'Aeon'
Aeon::Rake::Task.new(:aeon) { |t| t.tolerate 5 }

desc 'Aeon store'
Aeon::Rake::Store.new(:aeon_store) 


desc 'Runs specs'
RSpec::Core::RakeTask.new do |t|
end

task :default => :spec

