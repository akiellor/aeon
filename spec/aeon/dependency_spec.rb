require 'spec_helper'
require 'aeon'

describe Aeon::Dependency do
  subject { Aeon::Dependency.new(repo, "gem", Gem::Version.new("2.3.4")) }
  
  let(:repo) { mock(:repo, :newer_than => [mock(:dependency), mock(:dependency) ]) }
 
  context "remote version is 1 minor version ahead" do
    its(:score) { should == 2 }
  end
end

