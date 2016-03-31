require 'json'
require 'singleton'
class Database
  include Singleton

  TABLES = [:projects, :backings]
  FILE_PATH = 'lib/db.json'

  class TableDoesNotExistError < ArgumentError; end

  # def self.load
  #   if File.exist?(FILE_PATH)
  #     data = JSON.parse(File.read(FILE_PATH))
  #       .reduce({}){ |memo, (k,v)| memo[k.to_sym] = v; memo }
  #     data[:projects] = data[:projects].reduce([]){ |accum, v| accum << Models::Project.new(v) }
  #     data[:backings] = data[:backings].reduce([]){ |accum, v| accum << Models::Backing.new(v) }
  #   else
  #     data = Hash[TABLES.map { |x| [x, []] }]
  #   end
  #   new(data)
  # end

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

# 1/20
# extract method checking that tables exist [DONE]
# db.table(:projects).find {||} [DONE]
# stop passing the app - just pass the db [DONE]
# move the formatting cents thing to util class [DONE]
# create a custom error for calling a nonexistent table on the database instead of KeyError (key error is for fetch method - brackets returns nil)
# refactor the luhn method
# get json db to work
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
