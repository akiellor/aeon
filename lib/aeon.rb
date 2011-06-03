require 'aeon/version'
require 'net/http'
require 'uri'
require 'active_support'

module Aeon
  def self.score dependencies = Dependency.outdated
    dependencies.map(&:score).inject(0) {|sum, score| sum + score}
  end

  class VersionDelta
    attr_reader :offset, :delta

    def initialize offset, delta
      @offset = offset
      @delta = delta
    end

    def magnitude
      10.rpower(offset) * delta
    end

    def == other
      other.offset == offset && other.delta == delta
    end

    def same?
      offset == -1
    end

    def self.same
      new(-1, 0)
    end
  end

  class Version
    attr_reader :segments, :number

    def initialize version, prerelease
      @number = version
      @segments = version.split('.')
      @prerelease = prerelease
    end

    def prerelease?
      @prerelease
    end

    def compare other
      pairs = @segments.zip(other.segments) and pairs.each_with_index do |dot_pair, index|
        r = dot_pair[0].to_i - dot_pair[1].to_i
        if r != 0
          return VersionDelta.new((pairs.size - 1 - index), r)
        end
      end
      return VersionDelta.same
    end

    def == other
      equals_method = :"#{other.class.to_s.gsub('::', '__').downcase}_equals"
      respond_to?(equals_method) ? send(equals_method, other) : false
    end

    def aeon__version_equals other
      @number == other.number && @prerelease == other.prerelease?
    end

    def string_equals other
      @number == other
    end
  end

  class DependencyException < Exception
  end

  class Dependency
    attr_reader :name, :version

    def self.outdated
      Bundler.definition.specs.map do |spec|
        Dependency.for_version spec.name, spec.version.to_s
      end.select {|dep| dep.outdated?}
    end

    def self.all name
      if res = Net::HTTP.get(URI.parse("http://rubygems.org/api/v1/versions/#{name}"))
        ActiveSupport::JSON.decode(res).map do |dep|
          Dependency.new name, Version.new(dep['number'], dep['prerelease']) 
        end
      else
        raise DependencyException, "Dependency #{name} not found."
      end
    end

    def self.latest name
      all(name).select { |dep| dep.stable? }.first
    end

    def self.for_version name, version
      all(name).detect { |dep| dep.version == version }
    end

    def stable?
      !@version.prerelease?
    end

    def initialize name, version
      @name = name
      @version = version
    end

    def score
      latest.version.compare(@version).magnitude
    end

    def outdated?
      !latest.version.compare(@version).same?
    end

    def latest
      self.class.latest(name)
    end
  end
end
