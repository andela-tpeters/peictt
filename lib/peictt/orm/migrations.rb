module Peictt
  class Migrations
    def create_table(table_name)
      @table_name = table_name.to_s.pluralize
      yield self
      migrate
    end

    def drop(table_name)
      @table_name = table_name
      Database.execute_query drop_table_query
      true
    end

    def timestamps
      table_properties << "created_at DATETIME"
      table_properties << "updated_at DATETIME"
    end
    
    private

    def table_properties
      @table_properties ||= []
    end


    def migrate
      Database.execute_query create_table_query
      true
    end

    def parse_options(options = {})
      Peictt::ConstraintsParser.parse options
    end

    def create_table_query
      "CREATE TABLE IF NOT EXISTS #{@table_name}"\
      "(#{@table_properties.join ', '})"
    end

    def drop_table_query
      "DROP TABLE IF EXISTS #{@table_name}"
    end

    def method_missing(type, *args)
      @column_name = args[0]
      @column_type = type.to_s.upcase
      @options = args[1] if args[1].is_a? Hash
      table_properties << "#{@column_name} #{@column_type} "\
      "#{parse_options(@options.dup).join(' ')}"
      @options = {}
    end

    def respond_to_missing?(type, include_private = false)
      super
    end
  end
end
