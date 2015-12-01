# TO DO:
# - More refactoring
# - Refactor tests
# - get tests to stop displaying warnings about reassigning constants

require 'rubygems'
require 'bundler/setup'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/behaviors/*.rb'].each {|file| require file }

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
      input = gets.chomp
      unless input == ""
        input_split = input.split(" ")
        case input_split[0].downcase
        when "project"
          CreateProject.perform(self, input_split[1], input_split[2])
        when "back"
          CreateBacking.perform(self, input_split[1], input_split[2], input_split[3], input_split[4])
        when "list"
          ListProjectBackings.perform(self, input_split[1])
        when "backer"
          ListUserBackings.perform(self, input_split[1])
        when "help"
          puts App::HELP
        when "exit"
          break
        else
          puts "ERROR: invalid request. type help for more info."
        end
      end
    end
  end

  def self.format_cents(input)
    sprintf("%.2f", input)
  end
end