require "spec_helper"

describe Peictt::Parser::JSON do
  before do
    @file = File.read(File.expand_path("spec/test.json"))
    class Test
      def initialize
        @name = "Testing name"
      end
    end

    @test_file = Test.new
  end
  describe '#render' do
    it "parses the instance variable name" do
      result = JSON.parse Peictt::Parser::JSON.new(@file).render(@test_file)
      expect(result["test_name"]).to eq "Testing name"
    end

    it "parses the local variables" do
      result = JSON.parse Peictt::Parser::JSON.new(@file).render(nil, {name: "Cool"})
      expect(result["name"]).to eq "Cool"
    end

    it "parses both instance and local variables" do
      result = JSON.parse Peictt::Parser::JSON.new(@file).render(@test_file, {name: "Cool"})
      expect(result["name"]).to eq "Cool"
      expect(result["test_name"]).to eq "Testing name"
    end
  end
end
