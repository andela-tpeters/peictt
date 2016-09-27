require "spec_helper"

describe Peictt::ConstraintsParser do
  describe '#parse' do

    context 'primary key constraint' do
      it "returns array that include PRIMARY KEY" do
        constraint = Peictt::ConstraintsParser.parse(primary_key: true)
        expect(constraint).to include "PRIMARY KEY"
      end
    end

    context 'unique constraint' do
      it "returns array that include UNIQUE" do
        constraint = Peictt::ConstraintsParser.parse(unique: true)
        expect(constraint).to include "UNIQUE"
      end
    end

    context 'autoincrement constraint' do
      it "returns array that include AUTOINCREMENT" do
        constraint = Peictt::ConstraintsParser.parse(auto_increment: true)
        expect(constraint).to include "AUTOINCREMENT"
      end
    end

    context 'null constraint' do
      it "returns array that include NULL" do
        constraint = Peictt::ConstraintsParser.parse(null: true)
        expect(constraint).to include "NULL"
      end
    end

    context 'not_null constraint' do
      it "returns array that include NOT NULL" do
        constraint = Peictt::ConstraintsParser.parse(null: false)
        expect(constraint).to include "NOT NULL"
      end
    end


    context 'default constraint is set to empty' do
      it "returns array that include default as empty string" do
        constraint = Peictt::ConstraintsParser.parse(default: "")
        expect(constraint).to include "DEFAULT ''"
      end
    end

    context 'default constraint is set' do
      it "returns array that include default" do
        constraint = Peictt::ConstraintsParser.parse(default: "default")
        expect(constraint).to include "DEFAULT 'default'"
      end
    end
  end
end
