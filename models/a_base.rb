module Models
  class Base
    attr_accessor :name, :db

    def initialize(attributes = {})
      attributes.each { |k, v| send("#{k}=", v) }
    end

    def save
      begin
        if validate
          db.add(self.class::TABLE, self)
          true
        else
          false
        end
      rescue KeyError => error
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

    # def from_json!(string)
    #   JSON.parse(string)
    #     .each { |var, val| self.instance_variable_set(var,val) }
    # end
  end
end
