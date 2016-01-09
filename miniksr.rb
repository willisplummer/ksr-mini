# TO DO:
# create an instance of REPL to handle these behaviors in run method
# fix the tests

require 'rubygems'
require 'bundler/setup'

["lib", "models", "behaviors"].each do |dir|
  Dir.glob(File.expand_path("./#{dir}/*.rb")).each {|file| require file }
end

class App
  attr_reader :database
  HELP = <<-STR
    please use one of the following commands:

    project <project> <target amount>
    back <given name> <project> <credit card number> <backing amount>
    list <project>
    backer <given name>
  STR

  def initialize
    puts "now running mini-ksr"
    @database = Database.new
  end

  def run
    while true
      print "> "
      input = gets.chomp.split(" ")
      next if input.empty?
      case input[0].downcase
      when "project"
        Behaviors::CreateProject.perform(app: self, name: input[1], goal: input[2])
      when "back"
        Behaviors::CreateBacking.perform(app: self, name: input[1], project: input[2], cc: input[3], amount: input[4])
      when "list"
        Behaviors::ListProjectBackings.perform(app: self, project: input[1])
      when "backer"
        Behaviors::ListUserBackings.perform(app: self, name: input[1])
      when "help"
        puts App::HELP
      when "exit"
        break
      else
        puts "ERROR: invalid request. type help for more info."
      end
    end
  end

  def self.format_cents(input)
    sprintf("%.2f", input)
  end
end
