class CreateBacking
  attr_accessor :app, :name, :project, :cc, :amount, :db
  def initialize(attributes = {})
    attributes.each { |k, v| send("#{k}=", v) }
    @db = app.database
  end

  def self.perform(*args)
    new(*args).perform
  end

  def perform
    @project = @db.find(:projects) { |v| v.name == @project }
    if validate
      add_backing
      @project.add(@amount.to_f)
      puts "#{@name} backed project #{@project.name} for $#{App.format_cents(@amount)}"
      puts "#{@project.name} has now raised $#{App.format_cents(@project.raised)} of $#{@project.goal}"
    end
  end

  def add_backing
    b = Backing.new( { name: @name, project: @project.name, cc: @cc.to_i, amount: @amount.to_f } )
    @db.add(:backings, b)
  end

# should make this like the create project version, but at that point, maybe there should just be a validation class
# that takes either a :project or :backing key and then runs the appropriate validations.

  def validate
    errors = []

    errors << "ERROR: backer name must be between 4 and 20 characters" unless valid_length?
    errors << "ERROR: project does not exist" unless project_exists?
    errors << "ERROR: this card is invalid" unless valid_cc?
    errors << "ERROR: card has already been added by another user" unless unique_cc?
    errors << "ERROR: card fails luhn-10 validation" unless luhn?
    errors << "ERROR: pledge amount invalid; must be at least $1 and can only contain numbers" unless valid_pledge?
    errors << "ERROR: pledge amount contains too many decimal places" unless valid_cents?

    errors.each { |x| puts x }

    errors == []
  end

  def project_exists?
    !@project.nil?
  end

  def valid_length?
    4 <= @name.length && @name.length <= 20
  end

  def valid_pledge?
    @amount.to_i >= 1 && @amount.sub(".", "") == @amount.sub(".", "").to_i.to_s
  end

  def valid_cents?
    parts = @amount.split(".")
    parts[1].nil? || parts[1].length < 2
  end

  def valid_cc?
    @cc.length <= 19 && @cc == @cc.to_i.to_s
  end

  def unique_cc?
    match = @db.find(:backings) { |v| v.cc.to_s == @cc.to_s && v.name != @name }
    match.nil?
  end

  def luhn?
    sum = 0
    
    cc = @cc.to_s
    cc = "0#{cc}" if cc.length % 2 == 0

    digits = cc.split("")
    digits.each_with_index do |n, i|
      if i % 2 == 0
        sum += n.to_i
      else
        double = n.to_i * 2
        double = double.to_s.split("")
        double.each { |d| sum += d.to_i }
      end
    end

    sum % 10 == 0
  end 
end