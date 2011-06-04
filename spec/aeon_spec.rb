require 'spec_helper'
require 'aeon'

describe Aeon do
  let(:rake) { Aeon::Dependency.new(repo, 'rake', Gem::Version.new("1.2.3")) } 
  let(:repo) { mock(:repo, :newer_than => [mock(:dependency)]) }

  before { repo.stub(:outdated).and_return([rake]) }

  subject { Aeon.score repo }

  it { should == 1 }
end
