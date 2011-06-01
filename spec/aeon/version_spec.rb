require 'spec_helper'

require 'aeon'

describe Aeon::Version do
  subject { Aeon::Version.new("1.2.3") }

  its(:segments) { should == ["1", "2", "3"] }

  it "should return segment differences" do
    (Aeon::Version.new("2.5.7") - subject).should == [1, 3, 4]
  end
end
