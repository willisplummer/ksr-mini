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
    if validate
      @db.add(:projects, Project.new( { name: @name, goal: @goal.to_i } ))
      puts "Added #{@name} project with target of $#{@goal}"
    end
  end

  def validate
    validations = { valid_length?: "ERROR: project name must be between 4 and 20 characters", 
                    name_not_taken?: "ERROR: project name already taken" }

    errors = validations.inject([]) { |memo, (k,v)| send(k) ? memo : memo << v }
    errors.each { |x| puts x }

    errors == []
  end

  def name_not_taken?
    y = @db.find(:projects) { |v| v.name == @name }
    y.nil?
  end

  def valid_length?
    4 <= @name.length && @name.length <= 20
  end
end