module Models
  class Base
    attr_accessor :name, :db

    def initialize(attributes = {})
      attributes.each { |k, v| send("#{k}=", v) }
    end

    def save
      begin
        if validate
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
      self.instance_variables
        .inject({}){ |accum, v| accum[v.to_s.delete("@")] = self.instance_variable_get(v); accum }
        .to_json
    end
  end
end


#define valid_attributes for models in an array in a class level method
#instead of looping through attributes in initialize use the class level method
#validate input count in miniksr
