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
    @@instance ||= load
  end

  def self.reset!
    File.delete(self.filepath) if File.exist?(self.filepath)
    @@instance = nil
  end

  def self.load
    if File.exist?(self.filepath)
      data = JSON.parse(File.read(self.filepath))
        .reduce({}){ |memo, (k,v)| memo[k.to_sym] = v; memo }
      data[:projects] = data[:projects].reduce([]){ |accum, v| accum << Models::Project.from_json(v) }
      data[:backings] = data[:backings].reduce([]){ |accum, v| accum << Models::Backing.from_json(v) }
    else
      data = Hash[TABLES.map { |x| [x, []] }]
    end
    new(data)
  end

  class TableDoesNotExistError < ArgumentError; end

  def initialize(data)
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
    File.write(self.class.filepath, JSON.dump(@data))
  end

end
