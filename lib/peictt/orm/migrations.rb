module Peictt
  class Migrations
    def method_missing(type, *args)
      @column_name = args[0]
      @column_type = type.to_s.upcase
      @options = args[1] if args[1].is_a? Hash
      table_properties << "#{@column_name} #{@column_type} "\
      "#{parse_options(@options.dup).join(" ")}"
      @options = {}
    end

    def table_properties
      @table_properties ||= []
    end

    def create_table(table_name, &block)
      @table_name = "#{table_name}".pluralize
      yield self
      migrate
    end

    def drop(table_name)
      @table_name = table_name
      Database.execute_query drop_table_query
    end

    def migrate
      Database.execute_query create_table_query
      true
    end

    def parse_options(options = {})
      Peictt::ConstraintsParser.parse options
    end

    def create_table_query
      "CREATE TABLE IF NOT EXISTS #{@table_name} (#{@table_properties.join ", "})"
    end

    def drop_table_query
      "DROP TABLE IF EXISTS #{@table_name}"
    end
  end
end
