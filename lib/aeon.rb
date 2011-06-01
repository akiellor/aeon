require "aeon/version"

module Aeon
  def self.score
    Dependency.outdated.map(&:score).inject(0) {|sum, score| sum + score}
  end

  class Version
    attr_reader :segments

    def initialize version
      @segments = version.split('.')
    end

    def - other
      @segments.zip(other.segments).map do |dot_pair|
        r = dot_pair[0].to_i - dot_pair[1].to_i
        r < 0 ? 0 : r
      end
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
      dot_pair_delta = @remote_version - @local_version

      (0..(dot_pair_delta.size - 1)).to_a.inject(0) do |result, dot_offset|
        result + ((10.rpower dot_offset) * dot_pair_delta[(dot_pair_delta.size - 1) - dot_offset])
      end
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
