require 'json'

class Database

  TABLES = [:projects, :backings]

  def self.filepath=(filepath)
    @@filepath = filepath
  end

  def self.filepath
    @@filepath ||= 'lib/db.json'
  end

  def self.instance
    @@instance ||= new
  end

  class TableDoesNotExistError < ArgumentError; end

  def initialize
    if File.exist?(self.class.filepath)
      data = JSON.parse(File.read(self.class.filepath))
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

  def reset!
    File.delete(self.class.filepath) if File.exist?(self.class.filepath)
    @@instance = nil
  end

  protected

  def save
    File.write(self.class.filepath, JSON.dump(@data))
  end

end

# fix + refactor the luhn method
# write tests for database
# make tests more efficient
# check w ron re singleton db setup
