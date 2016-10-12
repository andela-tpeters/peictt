module Peictt
  class ConstraintsParser
    UNIQUE = "UNIQUE".freeze
    NULL = "NULL".freeze
    NOT_NULL = "NOT NULL".freeze
    PRIMARY_KEY = "PRIMARY KEY".freeze
    DEFAULT = "".freeze
    AUTO_INCREMENT = "AUTOINCREMENT".freeze

    @result = []
    def self.parse(constraints = {})
      constraints.each do |key, value|
        send(key, value)
      end
      result = @result.dup
      @result.clear
      result
    end

    def self.primary_key(value = false)
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
