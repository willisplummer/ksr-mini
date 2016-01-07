class ListUserBackings
  attr_accessor :app, :name, :db
  def initialize(attributes = {})
    attributes.each { |k,v| send("#{k}=", v) }
    @db = app.database
  end

  def self.perform(*args)
    new(*args).perform
  end

  def perform
    backings = @db.find_all(:backings) { |v| v.name = @name }
    if backings == []
      puts "ERROR: user does not exist"
    else
      backings.each { |v| puts "-- Backed #{v.project} for $#{App.format_cents(v.amount)}" }
    end
  end
end