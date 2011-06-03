# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "aeon/version"

Gem::Specification.new do |s|
  s.name        = "aeon"
  s.version     = Aeon::VERSION
  s.authors     = ["Andrew Kiellor"]
  s.email       = ["akiellor@gmail.com"]
  s.homepage    = ""

  s.summary     = %q{Aeon scores the age of your bundles dependencies.}
  s.description     = %q{Aeon is an analysis tool to score the age of your bundles dependencies.}
  s.rubyforge_project = "aeon"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('activesupport')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rake')
end
