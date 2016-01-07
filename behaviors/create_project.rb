module Behaviors
  class CreateProject
    VALIDATIONS = {
      valid_length?: "ERROR: project name must be between 4 and 20 characters", 
      name_not_taken?: "ERROR: project name already taken"
    }

    attr_accessor :app, :name, :goal, :db


    def perform
      if validate
        @db.add(:projects, Project.new( { name: @name, goal: @goal.to_i } ))
        puts "Added #{@name} project with target of $#{@goal}"
      end
    end

#chaining arguments
    def validate
      VALIDATIONS
        .inject([]) {|accum, (m,msg)| send(m) ? accum : accum << msg }
        .each {|error| puts error }
        .empty?
    end

    def name_not_taken?
      match = @db.find(:projects) { |v| v.name == @name }
      match.nil?
    end

    def valid_length?
      4 <= @name.length && @name.length <= 20
    end
  end
end