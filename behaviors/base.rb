module Behaviors
  class Base
    attr_accessor :app
    
    def initialize(attributes = {})
      attributes.each { |k, v| send("#{k}=", v) }
    end

    def self.perform(*args)
      new(*args).perform
    end

    def perform
      raise NotImplementedError, "must be defined in inherited class"
    end

    def db
      app.database
    end
  end
end