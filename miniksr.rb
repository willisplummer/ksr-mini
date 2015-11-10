# TO DO:
# - SHOULD BE ABLE TO BACK IN CENTS
# - can't back for negative money
# - TESTS
# - REFACTORRRRR
# - database? unnecessary?
# - help section
PROJECTS = []
BACKINGS = []

require 'rubygems'
require 'bundler/setup'
require "./models/backing.rb"
require "./models/project.rb"
require "./behaviors/create_project.rb"
require "./behaviors/create_backing.rb"

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
					contains = false
					PROJECTS.each do |i, v|
						if v.name == input_split[1]
							contains = true
							p = v
							p.backings.each do |i, v|
								puts "-- #{v[:user]} backed for $#{v[:amount]}"
							end
						end
					end
					if contains
						p.successful?
					else
						puts "ERROR: project does not exist"
					end
				when "backer"
					name = input_split[1]
					contains = false
					BACKINGS.each do |i, v|
						if v.name == name
							contains = true
							puts "-- Backed #{v.project} for $#{v.amount}"
						end
					end
					unless contains
						puts "ERROR: backer does not exist"
					end
				when "exit"
					break
				else
					puts "ERROR: invalid request"
				end
			end
		end
	end
end