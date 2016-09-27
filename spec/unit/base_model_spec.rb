require "spec_helper"

describe Peictt::BaseModel do
  before do
    Peictt::Database.execute_query "drop table if exists tests"
    Peictt::Database.execute_query "create table if not exists tests"\
    "(id integer primary key autoincrement, content string,"\
    " created_at datetime, updated_at datetime)"
    class Test < Peictt::BaseModel; end
    class NoTable < Peictt::BaseModel; end
  end

  describe '#initialize' do
    context "when table exists" do
      it "sets columns as methods of the model" do
        test_model = Test.new
        methods = test_model.methods - Object.methods
        expect(methods).to include(
          :id,
          :id=,
          :content,
          :content=,
          :created_at,
          :created_at=,
          :updated_at,
          :updated_at=,
          :save,
          :update,
          :destroy
          )
      end
    end

    context "when table does not exists" do
      it "no columns are set for methods" do
        no_table_model = NoTable.new
        methods = no_table_model.methods - Object.methods
        expect(methods).to include(:save, :update, :destroy)
        expect(methods).not_to include(
          :id,
          :id=,
          :content,
          :content=,
          :created_at,
          :created_at=,
          :updated_at,
          :updated_at=
        )
      end
    end
  end

  describe '#save' do
    before do
      @test_model = Test.new
      @test_model.content = "This is the present content"
    end

    context "when creating record" do
      it "returns true" do
        expect(@test_model.save).to be_truthy
      end
    end

    describe '#find_by' do
      context 'when record exists' do
        it "returns Test Object record" do
          @test_model.save
          record = Test.find_by id: 1
          expect(record).to be_instance_of Test
          expect(record.content).to eq "This is the present content"
        end
      end

      context 'when record does not exist' do
        it "returns nil" do
          record = Test.find_by id: 2
          expect(record).to be_nil
        end
      end
    end

    describe '#update' do
      context "through save method" do
        it "updates record" do
          @test_model.save
          record = Test.find_by id: 1
          record.content = "Updated"
          sleep 1
          record.save
          record = Test.find_by id: 1
          expect(record.content).to eq "Updated"
          expect(record.created_at).not_to eql record.updated_at
        end
      end

      context 'through update method' do
        it "returns model object" do
          @test_model.save
          record = Test.find_by id: 1
          updated_record = record.update content: "Changed"
          expect(updated_record).to be_instance_of Test
          expect(updated_record.content).to eq "Changed"
        end
      end
    end

    describe "#destroy" do
      it "returns true" do
        @test_model.save
        record = Test.find_by id: 1
        expect(record.destroy).to be_truthy
        expect(Test.find_by id: 1).to be_nil
      end
    end
  end

  describe '#destroy_all' do
    it "returns empty_array" do
      expect(Test.destroy_all).to eq []
    end
  end

  describe '#create' do
    it "returns Test Object" do
      item = Test.create content: "This is from create"
      expect(item).to be_instance_of Test
      expect(item.content).to eq "This is from create"
      expect(item.id).to eq 1
    end
  end

  describe '#all' do
    before do
      @item1 = Test.create content: "First"
      @item2 = Test.create content: "Second"
    end

    it "returns all record" do
      all = Test.all
      expect(all.size).to eq 2
      expect(all[0].id).to eq 1
      expect(all[0].content).to eq "First"
    end
  end
end
