require 'json'

class Database

  TABLES = [:projects, :backings]
  TABLES_TEST = {projects: "Models::Project", backings: "Models::Backing"}

  def self.filepath=(filepath)
    @@filepath = filepath
  end

  def self.filepath
    @@filepath ||= 'lib/db.json'
  end

  def self.instance
    @@instance ||= load
  end

  def self.reload!
    @@instance = load
  end

  def self.reset!
    File.delete(self.filepath) if File.exist?(self.filepath)
    @@instance = nil
  end

  def self.load
    if File.exist?(self.filepath)
      data = JSON.parse(File.read(self.filepath))
        .reduce({}){ |memo, (k,v)| memo[k.to_sym] = v; memo }
      TABLES.each do |table|
        data[table] = data[table].reduce([]){ |accum, v| accum << Object.const_get(TABLES_TEST[table]).from_json(v) }
      end
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

  def find(table, &block)
    Database.reload!
    attributes = Database.instance.table(table).find &block
    Object.const_get(TABLES_TEST[table]).new(attributes) unless attributes.nil?
  end

  def find_all(table, &block)
    Database.reload!
    results = Database.instance.table(table).find_all &block
    results == [] ? results : results.inject([]) { |accum, attributes| accum << Object.const_get(TABLES_TEST[table]).new(attributes) }
  end

  protected

  def save
    File.write(self.class.filepath, JSON.dump(@data))
  end

end
