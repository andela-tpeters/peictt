module Peictt
  class BaseModel
    def initialize
      @@table_name = self.class.to_s.downcase.pluralize
      self.class.set_methods
    end

    def self.set_methods
      columns = Database.connect.table_info(@@table_name).map { |column| column['name'] }
      make_methods columns
    end

    def self.make_methods(columns)
      columns.each do |column|
        attr_accessor column.to_sym
      end
    end
  end
end
