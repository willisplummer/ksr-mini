class CreateProject
  def self.perform(name, goal)
    if valid_length?(name) && name_not_taken?(name)
      PROJECTS << Project.new( { name: name, goal: goal.to_i } )
      puts "Added #{name} project with target of $#{goal}"
    end
  end

  def self.name_not_taken?(input)
    if App.get_project(input).nil?
      true
    else
      puts "ERROR: project name already taken"
      false
    end
  end

  def self.valid_length?(input)
    if 4 <= input.length && input.length <= 20
      true
    else
      puts "ERROR: project name must be between 4 and 20 characters"
      false
    end
  end
end