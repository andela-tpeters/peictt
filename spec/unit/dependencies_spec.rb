require "spec_helper"

describe "Dependencies" do
  before { @const = Object.const_missing "DependencyHelper" }
  describe "Object#const_missing" do
    it "loads dependencies" do
      expect(@const).to eq DependencyHelper
    end
  end

  describe 'String#to_snake_case' do
    it "converts camel_case to snake_case" do
      expect(@const.to_s.to_snake_case).to eq "dependency_helper"
    end
  end

  describe 'String#to_camel_case' do
    it "converts snake_case to camel_case" do
      expect("posts_controller".to_camel_case).to eq "PostsController"
    end
  end

  describe 'String#to_time' do
    it "converts str_time to time object" do
      expect("2016-01-01 00:00:00 +0100".to_time).to be_kind_of Time
    end
  end
end
