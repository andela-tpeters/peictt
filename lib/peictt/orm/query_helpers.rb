module Peictt
  module Orm
    module QueryHelpers
      def find_by(model, attributes)
        @table = model.to_s.downcase.pluralize
        @placeholders, @columns = set_columns_for_instance(attributes.keys)
        @values = attributes.values
        @combined_array = @columns.zip(@placeholders).
                          map { |item| item.join " = " }
        Database.execute_query(find_query, @values)[0]
      end

      def destroy(model)
        @id = model.id
        @table = model.class.to_s.to_snake_case.pluralize
        Database.execute_query destroy_query, [@id]
        true
      end

      def get_all(klass)
        table = klass.to_s.to_snake_case.pluralize
        Database.execute_query "SELECT * FROM #{table}"
      end

      def destroy_all(table)
        @table = table
        Database.execute_query destroy_all_query
      end

      def set_columns_for_instance(variables)
        placeholders = []
        columns = variables.map do |var|
          placeholders << "?"
          var.to_s.sub /[:@]/, ""
        end
        [placeholders, columns]
      end

      def get_values_for_instance(model, variables)
        variables.map do |var|
          model.instance_variable_get var
        end
      end

      def find_query
        "SELECT * FROM #{@table} WHERE #{@combined_array.join(' AND ')} "\
        " LIMIT 1"
      end

      def destroy_query
        "DELETE FROM #{@table} WHERE id = ?"
      end

      def destroy_all_query
        "DELETE FROM #{@table}"
      end
    end
  end
end
