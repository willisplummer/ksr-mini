require 'json'
require 'singleton'

class Database
  include Singleton

  TABLES = [:projects, :backings]
  FILE_PATH = 'lib/db.json'

  class TableDoesNotExistError < ArgumentError; end

  def initialize
    if File.exist?(FILE_PATH)
      data = JSON.parse(File.read(FILE_PATH))
        .reduce({}){ |memo, (k,v)| memo[k.to_sym] = v; memo }
      data[:projects] = data[:projects].reduce([]){ |accum, v| accum << Models::Project.new(v) }
      data[:backings] = data[:backings].reduce([]){ |accum, v| accum << Models::Backing.new(v) }
    else
      data = Hash[TABLES.map { |x| [x, []] }]
    end
    @data = data
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

end

# fix the tests
# refactor the luhn method
