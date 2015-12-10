class Database
  #data hash instead of two arrays
  #instead of instance variable for projects and instance variable for backings - two keys whose values are arrays
  #types become accessors
  #look into replacing puts with exceptions e.g. on line 42 // porcelain vs. plumbing - db is all plumbing
  #different styles of arguments - kw args, attributes =, splat, etc.
  #refactor booleans to be booleans, use an @errors instance variable - look at the active record errors documentation
  #create a where and a find method - take a hash and compare whatever you pass in the hash to the object that is stored in that table

  TABLES = [:projects, :backings]

  def initialize
    @data = {}
    TABLES.each { |k| @data[k]= [] }
  end


# ways to pass a block to find:

  def find(table, &block)
    return nil unless block_given?
    @data[table].find(&block)
  end

  def find(table)
    return nil unless block_given?
    @data[table].find { |record| yield(record) }
  end

  def find(table, conditions)
    @data[table].find { |row| conditions.all? { |k, v| row.send(k) == v } }
  end

  def where(table, accessor, value)
    @data[table].find_all { |v| v.send(accessor) == value }
  end

  def add(table, object)
    @data[table] << object
  end
end