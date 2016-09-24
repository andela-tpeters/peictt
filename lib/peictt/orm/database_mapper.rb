module Peictt
  class DatabaseMapper
    def initialize(model, action = :create)
      @table_name = model.class.to_s.downcase.pluralize
      @model = model
      @action = action
      @variables = model.instance_variables
      set_columns_and_values
      add_timestamps
      self
    end

    def save
      Database.execute_query query, @values
      true
    end

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

    def build_create_query
      "INSERT INTO #{@table_name} (#{@columns.join(', ')})"\
      "VALUES (#{@q_holders.join(', ')})"
    end

    def build_update_query

    end

    def set_columns_and_values
      @q_holders, @columns = self.class.columns @variables
      @values = self.class.values @model, @variables
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

    def add_timestamps
      @q_holders << "?" if create?
      @q_holders << "?"
      @columns << "created_at" if create?
      @columns << "updated_at"
      @values << Time.now.to_s if create?
      @values << Time.now.to_s
    end

    def self.find_by(model, attributes)
      @table_name = model.to_s.downcase.pluralize
      @q_holders, @columns = columns attributes.keys
      @values = attributes.values
      @combined_array = @columns.zip(@q_holders).map { |item| item.join " = " }
      Database.execute_query(find_query, @values)[0]
    end

    def self.find_query
      "SELECT * FROM #{@table_name} WHERE #{@combined_array.join(' AND ')} LIMIT 1"
    end
  end
end
