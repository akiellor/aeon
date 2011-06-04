require 'spec_helper'
require 'aeon'

describe Aeon::Dependency do
  subject { Aeon::Dependency.new("gem", Gem::Version.new("2.3.4")) }
  
  let(:newer) { [mock(:dependency), mock(:dependency) ] }
 
  before { subject.stub(:newer).and_return(newer) }

  context "remote version is 1 minor version ahead" do
    its(:score) { should == 2 }
  end
end

