require "spec_helper"

describe Peictt::Database do

  describe "connection" do
    it "returns database connection" do
      connection = Peictt::Database.connect
      expect(connection).to be_kind_of SQLite3::Database
    end
  end

  describe '#execute_query' do
    it "creates table" do
      query = "create table if not exists posts(id integer auto increment primary key, title string)"
      expect(
        Peictt::Database.execute_query query
      ).to eq []
    end

    it "gets table info" do
      info = Peictt::Database.connect.table_info("posts")
      expect(info[0]["name"]).to eq "id"
      expect(info[1]["name"]).to eq "title"
    end

    it "drops table" do
      query = "drop table if exists posts"
      expect(Peictt::Database.execute_query query).to eq []
      query = "select * from posts"
      expect { Peictt::Database.execute_query query }.to raise_error SQLite3::SQLException
    end
  end
end
