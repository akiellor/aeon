require 'spec_helper'
require 'aeon'

describe Aeon do
  let(:rake) { Aeon::Dependency.new('rake', Aeon::Version.new("1.2.3", false)) } 
  subject { Aeon.score [rake] }

  before { rake.stub(:latest).and_return(Aeon::Dependency.new('rake', Aeon::Version.new('2.5.7', false))) }

  it { should == 100 }
end
