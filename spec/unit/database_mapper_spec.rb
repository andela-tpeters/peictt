require "spec_helper"

describe Peictt::DatabaseMapper do
  before do
    class Test < Peictt::BaseModel; end
    @model = Test.new
  end

  describe '#initialize' do
    it "returns default instance of DatabaseMapper" do
      db_mapper = Peictt::DatabaseMapper.new @model
      expect(db_mapper).to be_instance_of Peictt::DatabaseMapper
      expect(db_mapper.instance_variable_get(:@action)).to eq :create
      expect(Peictt::DatabaseMapper.table).to eq "tests"
    end

    context 'update @action' do
      it "returns update instance of DatabaseMapper" do
        db_mapper = Peictt::DatabaseMapper.new @model, :update
        expect(db_mapper.instance_variable_get(:@action)).to eq :update
      end
    end
  end

  describe '#save' do
    before do
      Peictt::Database.execute_query "drop table if exists tests"
      Peictt::Database.execute_query "create table if not exists tests "\
      "(id INTEGER PRIMARY KEY AUTOINCREMENT, content STRING,"\
      "created_at DATETIME, updated_at DATETIME)"
    end

    context 'create new test' do
      it "inserts a new test to the table" do
        @model = Test.new
        @model.content = "This is the first content"
        expect(Peictt::DatabaseMapper.new(@model).save).to be_truthy
      end
    end

    context 'update tests' do
      it "updates existing test record" do
        @model.content = "This is the first content"
        Peictt::DatabaseMapper.new(@model).save
        model = Test.find_by id: 1
        model.content = "This is the updated content"
        model.created_at = model.created_at.to_s
        model.updated_at = model.updated_at.to_s
        expect(Peictt::DatabaseMapper.new(model, :update).save).to be_truthy
        expect(Test.find_by(id: 1).content).to eq "This is the updated content"
      end
    end
  end

  describe '#find_by' do
    context 'when item does not exist' do
      it "returns nil" do
        expect(Peictt::DatabaseMapper.find_by(Test, id: 2)).to be_nil
      end
    end

    context 'when item exist' do
      it "returns array of values" do
        result = Peictt::DatabaseMapper.find_by(Test, id: 1)
        expect(result[0]).to eq 1
        expect(result[1]).to eq "This is the updated content"
      end
    end
  end

  describe '#get_all' do
    it "return array of all items in the table" do
      result = Peictt::DatabaseMapper.get_all Test
      expect(result).to be_kind_of Array
      expect(result.size).to eq 1
    end
  end

  describe "#destroy" do
    def create
      @model.content = "This is for deleting from the db"
      Peictt::DatabaseMapper.new(@model).save
    end
    it "deletes record from database" do
      create
      item = Test.find_by id: 2
      expect(Peictt::DatabaseMapper.destroy(item)).to be_truthy
      expect(Peictt::DatabaseMapper.find_by(Test, id: 2)).to be_nil
    end
  end

  describe '#destroy_all' do
    it "clears the database record" do
      expect(Peictt::DatabaseMapper.destroy_all 'tests').to eq []
      expect(Peictt::DatabaseMapper.get_all Test).to eq []
    end
  end
end
