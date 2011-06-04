require 'aeon/version'
require 'net/http'
require 'uri'
require 'active_support'

module Aeon
  def self.score dependencies = Dependency.outdated
    dependencies.map(&:score).inject(0) {|sum, score| sum + score}
  end

  class DependencyException < Exception
  end

  class Dependency
    attr_reader :name, :version
  
    def self.all name
      @results ||= {}
      @results[name] or @results[name] = ActiveSupport::JSON.decode(Net::HTTP.get(URI.parse("http://rubygems.org/api/v1/versions/#{name}"))).map do |dep|
        Dependency.new name, Gem::Version.new(dep['number']) 
      end
    end

    def self.outdated
      Bundler.definition.specs.map do |spec|
        Dependency.for_version spec.name, spec.version
      end.select {|dep| dep.outdated?}
    end

    def self.stable name
      all(name).select { |dep| dep.stable? }
    end

    def self.latest name
      stable(name).first
    end

    def self.for_version name, version
      all(name).detect { |dep| dep.version.eql? version }
    end

    def self.newer_than name, version
      stable(name).select {|dep| dep.version > version }
    end

    def initialize name, version
      @name = name
      @version = version
    end

    def stable?
      !@version.prerelease?
    end

    def score
      newer.size
    end

    def outdated?
      latest.version > @version
    end

    def newer
      self.class.newer_than(name, @version)
    end

    def latest
      self.class.latest(name)
    end
  end
end
