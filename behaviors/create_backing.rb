class CreateBacking
  attr_accessor :app, :name, :project, :cc, :amount, :db
  def initialize(attributes = {})
    attributes.each { |k, v| send("#{k}=", v) }
    @db = app.database
  end

  def self.perform(app, name, project, cc, amount)
    cb = CreateBacking.new( { app: app, name: name, project: project, cc: cc, amount: amount } )
    if cb.valid?
      project = cb.db.search("project", cb.project)
      cb.add_backing
      project.add(cb.amount.to_f)
      puts "#{cb.name} backed project #{cb.project} for $#{app.format_cents(cb.amount)}"
      puts "#{project.name} has now raised $#{app.format_cents(project.raised)} of $#{project.goal}"
    end
  end

  def valid?
    if valid_length? && valid_cc? && luhn? && valid_pledge? && valid_cents? && project_exists? && unique_cc?
      true
    else
      false
    end
  end

  def add_backing
    b = Backing.new( { name: @name, project: @project, cc: @cc.to_i, amount: @amount.to_f } )
    @db.add("backing", b)
  end

  def project_exists?
    unless @db.search("project", @project)
      puts "Error: project does not exist"
      false
    else
      true
    end
  end

  def valid_length?
    if 4 <= @name.length && @name.length <= 20
      true
    else
      puts "ERROR: backer name must be between 4 and 20 characters"
      false   
    end
  end

  def valid_pledge?
    if @amount.to_i >= 1 && @amount.sub(".", "") == @amount.sub(".", "").to_i.to_s
      true
    else
      puts "Error: pledge amount invalid; must be at least $1 and can only contain numbers"
      false
    end
  end

  def valid_cents?
    parts = @amount.split(".")
    if !parts[1].nil? && parts[1].length > 2
      puts "Error: pledge amount contains too many decimal places"
      false
    else
      true
    end
  end

  def valid_cc?
    if @cc.length <= 19 && @cc == @cc.to_i.to_s
      true
    else
      puts "ERROR: this card is invalid"
      false
    end
  end

  def unique_cc?
    match = @db.match_cc(@cc, @name)
    if match.nil?
      true
    else
      puts "ERROR: card has already been added by another user"
      false
    end
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

    if sum % 10 == 0
      true
    else 
      puts "ERROR: card fails luhn-10 validation"
      false
    end
  end 
end