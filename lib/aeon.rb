require 'aeon/version'
require 'net/http'
require 'uri'
require 'active_support'
require 'bundler'

module Aeon
  def self.score repo = RubyGemsRepository.new
    repo.outdated.map(&:score).inject(0) {|sum, score| sum + score}
  end

  class Repository
    def all
      raise "Unimplemented"
    end

    def outdated
      Bundler.definition.specs.map do |spec|
        for_version spec.name, spec.version
      end.select {|dep| dep.outdated?}
    end

    def stable name
      all(name).select { |dep| dep.stable? }
    end

    def latest name
      stable(name).first
    end

    def for_version name, version
      all(name).detect { |dep| dep.version.eql? version }
    end

    def newer_than name, version
      stable(name).select {|dep| dep.version > version }
    end
  end

  class RubyGemsRepository < Repository
    def all
      @results ||= {}
      @results[name] or @results[name] = ActiveSupport::JSON.decode(Net::HTTP.get(URI.parse("http://rubygems.org/api/v1/versions/#{name}"))).map do |dep|
        Dependency.new self, name, Gem::Version.new(dep['number']) 
      end
    end
  end

  class Dependency
    attr_reader :name, :version, :repository

    def initialize repository, name, version
      @repository = repository
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
      @repository.newer_than(name, @version)
    end

    def latest
      @repository.latest(name)
    end

    def latest?
      latest == self
    end

    def == other
      @repository == other.repository && @name == other.name && @version == other.version
    end
  end
end
