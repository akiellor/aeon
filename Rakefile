require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'aeon/rake'

namespace :aeon do
  desc 'Aeon tollerance'
  Aeon::Rake::Old.new(:old) { |t| t.tolerate 5 }

  desc 'Tag build with aeon score'
  Aeon::Rake::Tag.new(:tag)

  desc 'Show the Aeon score for a commit'
  Aeon::Rake::Show.new 
end

desc 'Runs specs'
RSpec::Core::RakeTask.new do |t|
end

task :default => :spec

