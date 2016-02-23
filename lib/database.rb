require 'json'
class Database
  TABLES = [:projects, :backings]

  class TableDoesNotExistError < ArgumentError; end

  def initialize
    db_structure = Hash[TABLES.map { |x| [x, []] }]
    data_file = File.open("db.json","r+") do |f|
      f.write(db_structure.to_json)
    end
    @data = JSON.parse(data_file)
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

# 1/20
# fix all of the tests
# move the database into a file - load the contents of the file in the db methods, stop passing the app (use json or csv)
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
