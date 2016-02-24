require 'json'
class Database
  TABLES = [:projects, :backings]
  FILE_PATH = 'lib/db.json'

  class TableDoesNotExistError < ArgumentError; end

  def self.load
    if File.exist?(FILE_PATH)
      data = JSON.parse(File.read(FILE_PATH))
      .reduce({}){ |memo, (k,v)| memo[k.to_sym] = v; memo }
    else
      data = Hash[TABLES.map { |x| [x, []] }]
    end
    new(data)
  end

  def initialize(data)
    @data = data
  end

  def find(table, &block)
    raise(ArgumentError, "no block given") unless block_given?
    table_exists?(table)
    @data[table].find(&block)
  end

  def find_all(table, &block)
    raise(ArgumentError, "no block given") unless block_given?
    table_exists?(table)
    @data[table].find_all(&block)
  end

  def add(table, object)
    table_exists?(table)
    @data[table] << object
    save
  end

  def table_exists?(table)
    raise(KeyError, "the specified table '#{table}' does not exist") unless TABLES.include?(table)
  end

  protected

  def save
    File.write(FILE_PATH, JSON.dump(@data))
  end

end

# 1/20
# fix all of the tests
# extract method checking that tables exist
# db.table(:projects).find {||}
# stop passing the app - just pass the db
# move the formatting cents thing to util class
# create a custom error for calling a nonexistent table on the database instead of KeyError (key error is for fetch method - brackets returns nil)
# marshaling vs serializing
# look at an interaction w/ a feature and follow where it goes (chargeback path in rosie)
# refactor the luhn method
# ~~~ javascript stuff ~~~ js for cats?,
# fix the tests


#SKILLS TO DEVELOP:
# - js + jquery (js for cats: http://jsforcats.com/, codeacademy etc)
# - rails
#   - presenter pattern - in the book,
#   - concerns - need to lookup,
#   - rails engine - what is it etc.
# - look at the engineering requirements https://github.com/kickstarter/wiki/pull/135/files

#MTA App - do they make you pay for cron jobs on heroku? sinatra + heroku seems good
# - httparty or excon for http requests
