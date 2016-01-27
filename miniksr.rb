require 'rubygems'
require 'bundler/setup'

# currently named the base model "a_base" so that it gets loaded first but i'm wondering what the best solution is
# have base files call the relevant files for them and then only call the base files here.
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
    self.run
  end

  def self.format_cents(input)
    sprintf("%.2f", input)
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
      abort
    else
      puts "ERROR: invalid request. type help for more info."
    end
  end
end
