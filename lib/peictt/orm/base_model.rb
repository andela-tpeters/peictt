module Peictt
  class BaseModel
    class << self
      attr_accessor :table
    end

    def initialize
      self.class.table = self.class.to_s.downcase.pluralize
      self.class.set_methods
    end

    def self.set_methods
      columns = Database.connect.table_info(self.class.table).map do |column|
        column["name"]
      end
      make_methods columns
    end

    def self.make_methods(columns)
      columns.each do |column|
        attr_accessor column.to_sym
      end
    end
  end
end
