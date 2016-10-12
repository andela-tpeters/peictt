module Peictt
  class DatabaseMapper
    extend Peictt::Orm::QueryHelpers

    class << self
      attr_accessor :table
    end

    def initialize(model, action = :create)
      self.class.table = model.class.to_s.downcase.pluralize
      @model = model
      @action = action
      @variables = model.instance_variables
      set_columns_and_values
      add_timestamps if create?
      self
    end

    def save
      Database.execute_query query, @values
      true
    end

    private

    def query
      if create?
        return build_create_query
      else
        return build_update_query
      end
    end

    def create?
      @action == :create
    end

    def set_columns_and_values
      @placeholders, @columns = self.class.set_columns_for_instance @variables
      @values = self.class.get_values_for_instance(@model, @variables)
    end

    def prepare_columns_and_values_for_update
      id_index = @columns.index "id"
      @columns.delete_at(id_index)
      id_value = @values.delete_at id_index
      @values << id_value
    end

    def add_timestamps
      @placeholders << "?"
      @placeholders << "?"
      @columns << "created_at"
      @columns << "updated_at"
      @values << Time.now.to_s
      @values << Time.now.to_s
    end

    def build_create_query
      "INSERT INTO #{self.class.table} (#{@columns.join(', ')})"\
      "VALUES (#{@placeholders.join(', ')})"
    end

    def build_update_query
      prepare_columns_and_values_for_update
      columns_and_placeholders = @columns.zip(@placeholders[1..-1]).
                                 map { |pair| pair.join " = " }
      "UPDATE #{self.class.table} SET #{columns_and_placeholders.join(', ')} "\
      "WHERE id = ?"
    end
  end
end
