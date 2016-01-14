module Models
  class Base
    attr_accessor :name, :db

    def initialize(attributes = {})
      attributes.each { |k, v| send("#{k}=", v) }
    end

    def save(database)
      @db = database
      begin
        if validate
          @db.add(self.class::TABLE, self)
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
  end
end
