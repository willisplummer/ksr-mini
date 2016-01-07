class Backing

  TABLE = :backings

  attr_accessor :name, :project, :cc, :amount
  
  def initialize(attributes = {})
    attributes.each { |k, v| send("#{k}=", v) }
  end

  def save(db)
    db.add(TABLE, self)
  end
end