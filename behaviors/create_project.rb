class CreateProject
  attr_accessor :app, :name, :goal, :db
  def initialize(attributes = {})
    attributes.each { |k, v| send("#{k}=", v) }
    @db = app.database
  end

  def self.perform(*args)
    new(*args).perform
  end

  def perform
    if valid_length? && name_not_taken?
      @db.add(:projects, Project.new( { name: @name, goal: @goal.to_i } ))
      puts "Added #{@name} project with target of $#{@goal}"
    end
  end

  def name_not_taken?
    y = @db.find(:projects) { |v| v.name == @name }
    if y.nil?
      true
    else
      puts "ERROR: project name already taken"
      false
    end
  end

  def valid_length?
    if 4 <= @name.length && @name.length <= 20
      true
    else
      puts "ERROR: project name must be between 4 and 20 characters"
      false
    end
  end
end