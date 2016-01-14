class Database
  TABLES = [:projects, :backings]

  class TableDoesNotExistError < ArgumentError; end

  def initialize
    @data = Hash[TABLES.map { |x| [x, []] }]
  end

  def find(table, &block)
    raise(ArgumentError, "no block given") unless block_given? 
    raise(KeyError, "the specified table '#{table}' does not exist" unless TABLES.include?(table)
    @data[table].find(&block)
  end

  def find_all(table, &block)
    raise(ArgumentError, "no block given") unless block_given? 
    raise(KeyError, "the specified table '#{table}' does not exist" unless TABLES.include?(table)
    @data[table].find_all(&block)
  end

  def add(table, object)
    raise(KeyError, "the specified table '#{table}' does not exist" unless TABLES.include?(table)
    @data[table] << object
  end
end

# things to learn more about:
# different styles of arguments - kw args, attributes =, splat, etc.

# 1/7
# TO DO:
# fix the tests
# error handling, more semantically meaningful to a computer - see example below
# datamapper vs activerecord patterns - borrow ron's book patterns of enterprise application architecture