require 'spec_helper'

require 'aeon'

describe Aeon::Version do
  subject { Aeon::Version.new("1.2.3", false) }

  its(:segments) { should == ["1", "2", "3"] }

  it { should_not be_prerelease }

  it "should return segment differences" do
    Aeon::Version.new("2.5.7", false).compare(subject).should == Aeon::VersionDelta.new(2, 1)
  end

  it { should == "1.2.3" }

  it { should_not == "1.2.4" }

  it { should == Aeon::Version.new("1.2.3", false) }

  it { should_not == Aeon::Version.new("1.2.4", false) }

  it { should_not == Aeon::Version.new("1.2.3", true) }

  it { should_not == {} }
end
