module Peictt
  class DatabaseMapper
    def initialize(model, action = :create)
      @model = model
      @action = action
      @variables = model.instance_variables
      set_columns_and_values
      add_timestamps
      self
    end

    def save
      begin
        Database.execute_query query, @values
      rescue Exception => e
        Database.connect.rollback
        return false
      end
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
      table_name = @model.class.to_s.downcase.pluralize
      "INSERT INTO #{table_name} (#{@columns.join(', ')})"\
      "VALUES (#{@q_holders.join(', ')})"
    end

    def set_columns_and_values
      @q_holders = []
      @columns = @variables.map do |var|
        @q_holders << "?"
        var.to_s.sub /[:@]/, ""
      end
      @values = @variables.map do |var|
        @model.instance_variable_get var
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
  end
end
