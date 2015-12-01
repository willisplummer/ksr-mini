class Database
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