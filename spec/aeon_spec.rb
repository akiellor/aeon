require 'spec_helper'
require 'aeon'

describe Aeon do
  subject { Aeon.score [Aeon::Dependency.new('rake', Aeon::Version.new("1.2.3"), Aeon::Version.new("2.3.4"))] }

  it { should == 100 }
end
