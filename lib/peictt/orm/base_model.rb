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
      Database.connect.table_info(self.table).
        map { |column| column['name'] }
    end

    def self.make_methods(columns)
      columns.each do |column|
        attr_accessor column.to_sym unless columns == "created_at" || "updated_at"
        if (column == "created_at") || (column == "updated_at")
          attr_reader column.to_sym
        else
          attr_accessor column.to_sym
        end
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
      find_by title: model.title
    end

    def update(attributes)
      attributes.each do |key, value|
        send("#{key}=", values)
      end
      self.updated_at = Time.now.to_s
      self
    end

    def self.find_by(attributes)
      self.table = self.to_s.downcase.pluralize
      result = DatabaseMapper.find_by self, attributes
      return result if result.nil?
      key_pair = columns.zip(result).to_h
      item = self.new key_pair
      parse_to_time item
      item
    end

    def destroy
      DatabaseMapper.destroy self
    end

    def self.destroy_all
      DatabaseMapper.destroy_all self.to_s.to_snake_case.pluralize
    end

    def self.parse_to_time(model)
      model.created_at = model.created_at.to_time unless model.created_at.nil?
      model.updated_at = model.updated_at.to_time unless model.updated_at.nil?
    end

    def self.where(search_params)
    end
  end
end
