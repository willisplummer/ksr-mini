class Database
  #data hash instead of two arrays
  #instead of instance variable for projects and instance variable for backings - two keys whose values are arrays
  #types become accessors
  #look into replacing puts with exceptions e.g. on line 42 // porcelain vs. plumbing - db is all plumbing
  #different styles of arguments - kw args, attributes =, splat, etc.
  #refactor booleans to be booleans, use an @errors instance variable - look at the active record errors documentation
  #create a where and a find method - take a hash and compare whatever you pass in the hash to the object that is stored in that table


  def initialize
    @projects = []
    @backings = []
  end

  def search(type, name)
    case type 
    when "project"
      t = @projects
    when "backing"
      t = @backings
    end
    t.find { |v| v.name == name }
  end

  def get_backings(type, name)
    case type
    when "user"
      @backings.find_all { |v| v.name == name }
    when "project"
      @backings.find_all { |v| v.project == name }
    end
  end

  def match_cc(cc, name)
    @backings.find { |v| v.cc.to_s == cc.to_s && v.name != name }
  end

  def add(type, object)
    case type 
    when "project"
      t = @projects
    when "backing"
      t = @backings
    else
      return "not a valid type"
    end
    t << object
  end
end