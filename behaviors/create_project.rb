module Behaviors
  class CreateProject < Base
    attr_accessor :name, :goal

    def perform
      project = Models::Project.new(name: name, goal: goal.to_i)
      puts "Added #{name} project with target of $#{goal}" if project.save
    end
  end
end
