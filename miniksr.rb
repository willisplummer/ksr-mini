# TO DO:
# - Tests for get_project method
# - More refactoring
# - Refactor tests

require 'rubygems'
require 'bundler/setup'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/behaviors/*.rb'].each {|file| require file }

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
					if get_project(input_split[1]).nil?
						CreateProject.perform(input_split[1], input_split[2])
					else
						puts "ERROR: project name already taken"
						next
					end
				when "back"
					project = get_project(input_split[2])
					if project.nil?
						puts "ERROR: project does not exist"
						next
					end
					CreateBacking.perform(input_split[1], project, input_split[3], input_split[4])
				when "list"
					project = get_project(input_split[1])
					if project.nil?
						puts "ERROR: project does not exist"
						next
					end
					ListProjectBackings.perform(project)
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

	def get_project(project)
		PROJECTS.each do |v|
			if v.name == project
				return v
			end
		end	
		return nil
	end
end