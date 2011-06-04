require 'spec_helper'
require 'aeon'

describe Aeon do
  let(:rake) { Aeon::Dependency.new('rake', Gem::Version.new("1.2.3")) } 
  subject { Aeon.score [rake] }

  before { rake.stub(:newer).and_return([Aeon::Dependency.new('rake', Gem::Version.new('2.5.7'))]) }

  it { should == 1 }
end
