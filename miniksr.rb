# TO DO:
# - SHOULD BE ABLE TO BACK IN CENTS
# - can't back for negative money
# - TESTS
# - REFACTORRRRR
# - database? unnecessary?
# - help section

require 'rubygems'
require 'bundler/setup'
require "./models/backing.rb"
require "./models/project.rb"
require "./behaviors/create_project.rb"
require "./behaviors/create_backing.rb"
require "./behaviors/list_project_backings.rb"
require "./behaviors/list_user_backings.rb"

PROJECTS = []
BACKINGS = []

class App
	def initialize
		puts "now running mini-ksr"
	end

	def run
		while true
			print "> "
			input = gets.chomp
			unless input == ""
				input_split = input.split(" ")
				case input_split[0].downcase
				when "project"
					CreateProject.perform(input_split[1], input_split[2])
				when "back"
					CreateBacking.perform(input_split[1], input_split[2], input_split[3], input_split[4])
				when "list"
					ListProjectBackings.perform(input_split[1])
				when "backer"
					ListUserBackings.perform(input_split[1])
				when "help"
					puts "please use one of the following commands:\n\n"
					puts "project <project> <target amount>"
					puts "back <given name> <project> <credit card number> <backing amount>"
					puts "list <project>"
					puts "backer <given name>"
				when "exit"
					break
				else
					puts "ERROR: invalid request. type help for more info."
				end
			end
		end
	end
end