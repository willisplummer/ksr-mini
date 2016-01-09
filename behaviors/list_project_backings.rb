module Behaviors
  class ListProjectBackings < Base
    attr_accessor :project
    def initialize(attributes = {})
      attributes.each { |k,v| send("#{k}=", v) }
      @db = app.database
    end

    def self.perform(*args)
      new(*args).perform
    end

    def perform
      @project = @db.find(:projects) { |v| v.name == @project }
      print_backings if project_exists?
    end

    def project_exists?
      if @project.nil?
        puts "ERROR: project does not exist"
        false
      else
        true
      end
    end

    def print_backings
      backings = @db.find_all(:backings) { |v| v.project == @project.name }
      if backings == []
        puts "#{@project.name} does not have any backings yet"
      else
        backings.each { |v| puts "-- #{v.name} backed for $#{App.format_cents(v.amount)}" }
        @project.successful?
      end
    end
  end
end