require 'rubygems'
require 'bundler/setup'

# have base files call the relevant files for them and then only call the base files here.
require './behaviors/base.rb'
require './models/base.rb'

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
    Database.load
    self.run
  end

  def run
    loop do
      read
    end
  end

  def read
    print "> "
    handle_input(gets.chomp.downcase.split(" "))
  end

  def handle_input(input)
    case input[0]
    when "project"
      Behaviors::CreateProject.perform(name: input[1], goal: input[2])
    when "back"
      Behaviors::CreateBacking.perform(name: input[1], project: input[2], cc: input[3], amount: input[4])
    when "list"
      Behaviors::ListProjectBackings.perform(project: input[1])
    when "backer"
      Behaviors::ListUserBackings.perform(name: input[1])
    when "help"
      puts App::HELP
    when "exit"
      abort
    else
      puts "ERROR: invalid request. type help for more info."
    end
  end
end

# write tests for database
# make tests more efficient (in terms of just focusing on their own stuff)
