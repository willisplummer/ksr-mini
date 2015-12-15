class Database
  #look into replacing puts with exceptions e.g. on line 42 // porcelain vs. plumbing - db is all plumbing
  #different styles of arguments - kw args, attributes =, splat, etc.
  #refactor booleans to be booleans, use an @errors instance variable - look at the active record errors documentation
  #create a where and a find method - take a hash and compare whatever you pass in the hash to the object that is stored in that table

  TABLES = [:projects, :backings]

  def initialize
    @data = TABLES.inject({}) do |hash, k| 
      hash[k] = [] 
      hash
    end
  end

  def find(table, &block)
    raise 'no block given' unless block_given? 
    raise 'table does not exist' unless TABLES.include?(table)
    @data[table].find(&block)
  end

  def find_all(table, &block)
    raise 'no block given' unless block_given? 
    raise 'table does not exist' unless TABLES.include?(table)
    @data[table].find_all(&block)
  end

  def add(table, object)
    raise 'table does not exist' unless TABLES.include?(table)
    @data[table] << object
  end
end