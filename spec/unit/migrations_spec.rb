require "spec_helper"

describe Peictt::Migrations do
  before do
    @migrator = Peictt::Migrations.new
  end
  describe '#change' do
    it "creates table" do
      expect(
        @migrator.create_table(:tests) do |table|
          table.integer :id, primary_key: true, auto_increment: true
          table.timestamps
        end
      ).to be_truthy
    end

    it "does not raise error" do
      expect do
        Peictt::Database.execute_query "select * from tests"
      end.not_to raise_error Exception
    end
  end

  describe '#drop' do
    it "drops the table in the database" do
      expect(@migrator.drop('tests')).to be_truthy
    end

    it "does raises error" do
      expect do
        Peictt::Database.execute_query "select * from tests"
      end.to raise_error Exception
    end
  end
end
