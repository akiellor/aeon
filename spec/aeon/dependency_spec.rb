require 'spec_helper'
require 'aeon'

describe Aeon::Dependency do
  subject { Aeon::Dependency.new(repo, "gem", Gem::Version.new("2.3.4")) }
  let(:repo) { mock(:repo) }
 
  context "repo has two newer versions" do
    let(:repo) { mock(:repo, :newer_than => [mock(:dependency), mock(:dependency)]) }
    
    before { repo.stub(:latest).and_return(Aeon::Dependency.new(repo, "gem", Gem::Version.new("2.3.10"))) }
                                           
    its(:score) { should == 2 }

    it { should_not be_latest }
    it { should be_outdated }
  end

  context "repo has no newer versions" do
    let(:repo) { mock(:repo, :newer_than => []) }
    
    before { repo.stub(:latest).and_return(Aeon::Dependency.new(repo, "gem", Gem::Version.new("2.3.4"))) }
    
    it { should be_latest }
    it { should_not be_outdated }
  end

  it { should == Aeon::Dependency.new(repo, "gem", Gem::Version.new("2.3.4")) }
  it { should_not == Aeon::Dependency.new(repo, "gem", Gem::Version.new("2.3.10")) }
  it { should_not == Aeon::Dependency.new(repo, "rails", Gem::Version.new("2.3.4")) }
  it { should_not == Aeon::Dependency.new(nil, "gem", Gem::Version.new("2.3.4")) }

  it { should be_stable }
end

