require 'spec_helper'
require 'aeon'

describe Aeon::Dependency do
  subject { Aeon::Dependency.new("gem", local_version, remote_version) }
  
  let(:local_version) { mock(:version) }
  let(:remote_version) { mock(:version, :- => delta) }
  
  context "remote version is 1 minor version ahead" do
    let(:delta) { [0, 1, 0] }

    its(:score) { should == 10 }
  end

  context "remote version is 2 minor versions ahead" do
    let(:delta) { [0, 2, 0] }

    its(:score) { should == 20 }
  end

  context "remote version is 2 point versions ahead" do
    let(:delta) { [0, 0, 2] }

    its(:score) { should == 2 }
  end

  context "remote version is 1 major version ahead" do
    let(:delta) { [1, 0, 0] }

    its(:score) { should == 100 }
  end
end
