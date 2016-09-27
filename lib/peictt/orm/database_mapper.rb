module Peictt
  class DatabaseMapper
    def initialize(model, action = :create)
      @table_name = model.class.to_s.downcase.pluralize
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

    def self.find_by(model, attributes)
      @table_name = model.to_s.downcase.pluralize
      @q_holders, @columns = columns attributes.keys
      @values = attributes.values
      @combined_array = @columns.zip(@q_holders).map { |item| item.join " = " }
      Database.execute_query(find_query, @values)[0]
    end

    def self.destroy(model)
      @id = model.id
      @table_name = model.class.to_s.to_snake_case.pluralize
      Database.execute_query destroy_query, [@id]
      true
    end

    def self.get_all(klass)
      table_name = klass.to_s.to_snake_case.pluralize
      Database.execute_query "SELECT * FROM #{table_name}"
    end

    def self.destroy_all(table_name)
      @table_name = table_name
      Database.execute_query destroy_all_query
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
      @q_holders, @columns = self.class.columns @variables
      @values = self.class.values @model, @variables
    end

    def prepare_columns_and_values_for_update
      id_index = @columns.index "id"
      @columns.delete_at id_index
      id_value = @values.delete_at id_index
      @values << id_value
    end

    def add_timestamps
      @q_holders << "?"
      @q_holders << "?"
      @columns << "created_at"
      @columns << "updated_at"
      @values << Time.now.to_s
      @values << Time.now.to_s
    end

    def self.columns(variables)
      q_holders = []
      columns = variables.map do |var|
        q_holders << "?"
        var.to_s.sub /[:@]/, ""
      end
      [q_holders, columns]
    end

    def self.values(model, variables)
      variables.map do |var|
        model.instance_variable_get var
      end
    end

    def build_create_query
      "INSERT INTO #{@table_name} (#{@columns.join(', ')})"\
      "VALUES (#{@q_holders.join(', ')})"
    end

    def build_update_query
      prepare_columns_and_values_for_update
      columns_and_q_holders = @columns.zip(@q_holders[1..-1]).
        map do |pair|
          pair.join " = "
        end
      "UPDATE #{@table_name} SET #{columns_and_q_holders.join(", ")} "\
      "WHERE id = ?"
    end

    def self.find_query
      "SELECT * FROM #{@table_name} WHERE #{@combined_array.join(' AND ')} "\
      " LIMIT 1"
    end


    def self.destroy_query
      "DELETE FROM #{@table_name} WHERE id = ?"
    end

    def self.destroy_all_query
      "DELETE FROM #{@table_name}"

    end

    def self.find_query
      "SELECT * FROM #{@table_name} WHERE #{@combined_array.join(' AND ')}"\
      "LIMIT 1"
    end
  end
end
