class Database
  #look into replacing puts with exceptions where applicable
  #different styles of arguments - kw args, attributes =, splat, etc.
  #refactor booleans to be booleans, use an @errors instance variable - look at the active record errors documentation

  TABLES = [:projects, :backings]


#couldnt figure out how to use tap for this?
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