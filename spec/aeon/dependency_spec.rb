require 'spec_helper'
require 'aeon'

describe Aeon::Dependency do
  subject { Aeon::Dependency.new("gem", local_version) }
  
  let(:local_version) { mock(:version) }
  let(:latest) { mock(:dependency, :version => mock(:version, :compare => delta)) }
 
  before { subject.stub(:latest).and_return(latest) }

  context "remote version is 1 minor version ahead" do
    let(:delta) { Aeon::VersionDelta.new(1, 1) }

    its(:score) { should == 10 }
  end

  context "remote version is 2 minor versions ahead" do
    let(:delta) { Aeon::VersionDelta.new(1, 2) }

    its(:score) { should == 20 }
  end

  context "remote version is 2 point versions ahead" do
    let(:delta) { Aeon::VersionDelta.new(0, 2) }

    its(:score) { should == 2 }
  end

  context "remote version is 1 major version ahead" do
    let(:delta) { Aeon::VersionDelta.new(2, 1) }

    its(:score) { should == 100 }
  end
end
