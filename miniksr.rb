# TO DO:
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
					CreateProject.perform(input_split[1], input_split[2])
				when "back"
					CreateBacking.perform(input_split[1], input_split[2], input_split[3], input_split[4])
				when "list"
					ListProjectBackings.perform(input_split[1])
				when "backer"
					ListUserBackings.perform(input_split[1])
				when "help"
					puts "please use one of the following commands:\n\nproject <project> <target amount>\nback <given name> <project> <credit card number> <backing amount>\nlist <project>\nbacker <given name>"
				when "exit"
					break
				else
					puts "ERROR: invalid request. type help for more info."
				end
			end
		end
	end

	def self.get_project(project)
		PROJECTS.each do |v|
			if v.name == project
				return v
			end
		end	
		return nil
	end

	def self.project_exists?(project)
		unless get_project(project).nil?
			true
		else
			puts "ERROR: project does not exist"
			false
		end
	end

	def self.format_cents(input)
		sprintf("%.2f", input)
	end
end