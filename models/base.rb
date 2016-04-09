module Models
  class Base
    attr_accessor :name

    def initialize(attributes = {})
      attributes.each { |k, v| send("#{k}=", v) }
    end

    def save
      begin
        if check_attributes && validate
          Database.instance.add(self.class::TABLE, self)
          true
        else
          false
        end
      rescue Database::TableDoesNotExistError => error
        Logger.log("Error saving to database: #{error}")
        puts "Could not save to database: #{error}"
        false
      end
    end

    def validate
      self.class::VALIDATIONS
        .inject([]) {|accum, (m,msg)| send(m) ? accum : accum << msg }
        .each {|error| puts error }
        .empty?
    end

    def to_json(options={})
      self.class::VALID_ATTRIBUTES
        .inject({}){ |accum, v| accum[v] = self.send(v); accum }
        .to_json
    end

    def self.from_json(data)
      formatted_hash = data.reduce({}){ |accum, (k, v)| accum[k.to_sym] = v; accum}
      # new(formatted_hash)
    end

    def check_attributes
      unless all_attributes_present?
        puts "ERROR: missing arguments; type 'help' for more info"
        false
      end
      true
    end

    def all_attributes_present?
      self.class::VALID_ATTRIBUTES
        .all?{|v| !self.send(v).nil?}
    end
  end
end
