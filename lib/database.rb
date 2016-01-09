class Database
  TABLES = [:projects, :backings]

  class TableDoesNotExistError < ArgumentError; end

  def initialize
    @data = Hash[TABLES.map { |x| [x, []] }]
  end

  def find(table, &block)
    raise(ArgumentError, "no block given") unless block_given? 
    raise(TableDoesNotExistError, "table does not exist") unless TABLES.include?(table)
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
# things to learn more about:
# different styles of arguments - kw args, attributes =, splat, etc.

# 1/7

# moving db -> lib
# error handling, more semantically meaningful to a computer - see example below
# base class for models + behaviors
# move validations to the base model
# constant in each model listing which validations it needs to have
# datamapper vs activerecord patterns - borrow ron's book patterns of enterprise application architecture


#EXAMPLE OF RAISING ERRORS AND RESCUING

# db = Database.new
# project = Project.new
# foo = Foo.new

# begin
#   db.add(:projects, project)
#   db.add(:foo, foo)
# rescue ArgumentError
#   db.remove(:projects, project)
#   db.remove(:foo, foo)
# rescue TableDoesNotExistError => e
#   Logger.log("oh shit i fucked  up")
#   raise e
# end