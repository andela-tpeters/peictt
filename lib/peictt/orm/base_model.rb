module Peictt
  class BaseModel
    class << self
      attr_accessor :table
    end

    def initialize(attributes = {})
      self.class.table = self.class.to_s.downcase.pluralize
      self.class.set_methods
      attributes.each do |key, value|
        send("#{key}=", value)
      end unless attributes.empty?
      self
    end

    def self.set_methods
      make_methods columns
    end

    def self.columns
      Database.connect.table_info(@@table_name).
        map { |column| column['name'] }
    end

    def self.make_methods(columns)
      columns.each do |column|
        attr_accessor column.to_sym
      end
    end

    def save
      if @id
        self.class.parse_time_to_s self
        return DatabaseMapper.new(self, :update).save
      else
        return DatabaseMapper.new(self, :create).save
      end
    end

    def self.parse_time_to_s(model)
      model.updated_at = Time.now.to_s
      model.created_at = model.created_at.to_s
    end

    def self.create(attributes)
      model = self.new(attributes)
      model.save
      model
    end

    def update(attributes)
      attributes.each do |key, value|
        send("#{key}=", values)
      end
      self.updated_at = Time.now.to_s
      self
    end

    def self.find_by(attributes)
      @@table_name = self.to_s.downcase.pluralize
      result = DatabaseMapper.find_by self, attributes
      return result if result.nil?
      key_pair = columns.zip(result).to_h
      key_pair["created_at"] = key_pair["created_at"].to_time unless
        key_pair["created_at"].nil?
      key_pair["updated_at"] = key_pair["updated_at"].to_time unless
        key_pair["updated_at"].nil?
      self.new key_pair
    end

    def destroy
      DatabaseMapper.destroy self
    end

    def self.destroy_all
      DatabaseMapper.destroy_all self.to_s.to_snake_case.pluralize
    end

    def self.where(search_params)
    end
  end
end
