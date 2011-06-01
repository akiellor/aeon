require "aeon/version"

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
  end

  class Version
    attr_reader :segments

    def initialize version
      @segments = version.split('.')
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
  end

  class Dependency
    attr_reader :name

    def initialize name, local_version, remote_version
      @name = name
      @local_version = local_version
      @remote_version = remote_version
    end

    def score
      @remote_version.compare(@local_version).magnitude
    end

    def self.outdated
      `gem outdated`.split("\n").map do |dep_line|
        if m = dep_line.match(/^([^\s]+) \(([^\s]+) < ([^\)]+)\)$/)
          name, local_version, remote_version = m.captures
          Dependency.new name, Version.new(local_version), Version.new(remote_version)
        else
          raise "Failed to parse line: #{depline}"
        end
      end
    end
  end
end
