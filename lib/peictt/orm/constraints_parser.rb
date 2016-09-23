module Peictt
  class ConstraintsParser
    UNIQUE = "UNIQUE"
    NULL = "NULL"
    NOT_NULL = "NOT NULL"
    PRIMARY_KEY = "PRIMARY KEY"
    DEFAULT =  ''
    AUTO_INCREMENT = "AUTOINCREMENT"

    @result = []
    def self.parse(constraints = {})
      constraints.each do |key, value|
        send(key, value)
      end
      result = @result.dup
      @result.clear
      result
    end

    def self.primary_key(value = PRIMARY_KEY)
      @result << PRIMARY_KEY if value
    end

    def self.unique(value = false)
      @result << UNIQUE if value
    end

    def self.auto_increment(value = false)
      @result << AUTO_INCREMENT if value
    end

    def self.null(value = false)
      @result << NULL if value
      @result << NOT_NULL unless value
    end

    def self.default(value = "")
      @result << "DEFAULT '#{value}'"
    end

  end
end
