class Backing
  attr_accessor :name, :project, :cc, :amount
  def initialize(attributes = {})
    attributes.each { |k, v| send("#{k}=", v) }
  end
end