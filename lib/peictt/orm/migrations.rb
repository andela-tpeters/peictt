module Peictt
  class Migrations

    def method_missing(type, *args)
      @column_name = args[0]
      @column_type = type.to_s.upcase
      @options = args[1] if args[1].is_a? Hash
      @options = parse_options if @options
      table_properties << "#{@column_name} #{@column_type} #{@options.join(" ")}"
    end

    def table_properties
      @table_properties ||= []
    end

    def create_table(table_name, &block)
      @table_name = table_name
      yield self
      migrate
    end

    def migrate
      Database.execute_query create_table_query
      true
    end

    def parse_options
      Peictt::ConstraintsParser.parse @options
    end

    def create_table_query
      "CREATE TABLE #{@table_name} IF NOT EXIST (#{@table_properties.join ", "})"
    end

  end
end
