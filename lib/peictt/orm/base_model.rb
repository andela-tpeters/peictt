module Peictt
  class BaseModel
    def initialize(attributes = {})
      self.class.table = self.class.to_s.downcase.pluralize
      self.class.set_methods
      attributes.each do |key, value|
        send("#{key}=", value)
      end unless attributes.empty?
      self
    end

    def save
      if @id
        self.class.parse_time_to_s self
        return DatabaseMapper.new(self, :update).save
      else
        return DatabaseMapper.new(self).save
      end
    end

    def update(attributes)
      attributes.each do |key, value|
        send("#{key}=", value)
      end
      save
      self
    end

    def destroy
      DatabaseMapper.destroy self
    end

    class << self
      attr_accessor :table
    end

    def self.table(klass = self)
      klass.to_s.downcase.pluralize
    end

    def self.destroy_all
      DatabaseMapper.destroy_all to_s.to_snake_case.pluralize
    end

    def self.all
      result = DatabaseMapper.get_all self
      all = []
      result.each do |row|
        all << convert_to_object(row)
      end
      all
    end

    def self.find_by(attributes)
      self.table = to_s.downcase.pluralize
      result = DatabaseMapper.find_by self, attributes
      return result if result.nil?

      convert_to_object result
    end

    def self.create(attributes)
      model = new(attributes)
      model.save
      find_by attributes
    end

    def self.set_methods
      make_methods columns
    end

    def self.parse_time_to_s(model)
      model.updated_at = Time.now.to_s if model.respond_to? :updated_at
      model.created_at = model.created_at.to_s if model.respond_to? :created_at
    end

    private_class_method

    def self.parse_to_time(model)
      model.created_at = model.created_at.to_time unless model.created_at.nil?
      model.updated_at = model.updated_at.to_time unless model.updated_at.nil?
    end

    def self.columns
      Database.connect.table_info(table).
        map { |column| column["name"] }
    end

    def self.make_methods(columns)
      columns.each do |column|
        attr_accessor column.to_sym
      end
    end

    def self.convert_to_object(result)
      key_pair = columns.zip(result).to_h
      item = new key_pair
      parse_to_time item
      item
    end
  end
end
