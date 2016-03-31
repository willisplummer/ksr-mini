require 'json'
require 'singleton'

class Database
  include Singleton

  TABLES = [:projects, :backings]
  FILE_PATH = 'lib/db.json'

  class TableDoesNotExistError < ArgumentError; end

  def initialize
    @data = load
  end

  def table(table)
    raise(TableDoesNotExistError, "the specified table '#{table}' does not exist") unless TABLES.include?(table)
    @data[table]
  end

  def add(table, object)
    table(table) << object
    save
  end

  protected

  def save
    File.write(FILE_PATH, JSON.dump(@data))
  end

  def load
    if File.exist?(FILE_PATH)
      data = JSON.parse(File.read(FILE_PATH))
        .reduce({}){ |memo, (k,v)| memo[k.to_sym] = v; memo }
      data[:projects] = data[:projects].reduce([]){ |accum, v| accum << Models::Project.new(v) }
      data[:backings] = data[:backings].reduce([]){ |accum, v| accum << Models::Backing.new(v) }
    else
      data = Hash[TABLES.map { |x| [x, []] }]
    end
  end

end

# extract method checking that tables exist [DONE]
# db.table(:projects).find {||} [DONE]
# stop passing the app - just pass the db [DONE]
# move the formatting cents thing to util class [DONE]
# create a custom error for calling a nonexistent table on the database instead of KeyError [DONE]
# get json db to work [DONE]
# fix the tests
# refactor the luhn method


#SKILLS TO DEVELOP:
# - js + jquery (js for cats: http://jsforcats.com/, codeacademy etc)
# - rails
#   - presenter pattern - in the book,
#   - concerns - need to lookup,
#   - rails engine - what is it etc.
# - look at the engineering requirements https://github.com/kickstarter/wiki/pull/135/files
