require 'spec_helper'
require 'aeon'

describe Aeon::VersionDelta do
  subject { Aeon::VersionDelta.new(1, 2) }

  its(:offset) { should == 1 }
  its(:delta) { should == 2 }
  it { should == Aeon::VersionDelta.new(1, 2) }

  it { should_not == Aeon::VersionDelta.new(2, 2) }
  it { should_not == Aeon::VersionDelta.new(1, 3) }
end
