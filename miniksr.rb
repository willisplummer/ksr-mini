# TO DO:
# - SHOULD BE ABLE TO BACK IN CENTS
# - TESTS
# - REFACTORRRRR
# - database? unnecessary?

require 'rubygems'
require 'bundler/setup'

class Backer
	def initialize(name, project, cc, amount)
		@name = name
		@project = project
		@cc = cc
		@amount = amount
	end

	def name
		@name
	end

	def project
		@project
	end

	def cc
		@cc
	end

	def amount
		@amount
	end
end

class Project
	def initialize(name, goal)
		@name = name
		@goal = goal
		@raised = 0
		@pledges = 0
		@backings = {}
		@backings_index = 1
	end

	def name
		@name
	end

	def goal
		@goal
	end

	def add(pledge, name)
		@raised += pledge
		@pledges += 1
		@backings[@backings_index] = { user: name, amount: pledge }
		@backings_index += 1
	end

	def raised
		@raised
	end

	def backings
		@backings
	end

	def successful?
		if @raised >= @goal
			puts "#{@name} is successful!"
		else
			puts "#{@name} needs $#{@goal - @raised} more dollars to be successful"
		end
	end
end

class App
	def initialize
		puts "now running mini-ksr"
	end

	def valid_length?(input)
		if 4 <= input.length && input.length <= 20
			return true
		else
			puts "ERROR: name must be between 4 and 20 characters"
			return nil
		end
	end

	def valid_cc?(input)
		if input.length <= 19 && input == input.to_i.to_s
			return true
		else
			puts "ERROR: this card is invalid"
			return nil
		end
	end

	def run
		projects = {}
		projects_index = 1
		backers = {}
		backings_index = 1
		while true
			print "> "
			input = gets.chomp
			unless input == ""
				input_split = input.split(" ")
				case input_split[0].downcase
				when "project"
					x = valid_length?(input_split[1])
					projects.each do |key, value|
						if value.name == input_split[1]
							puts "ERROR: project name already taken"
							x = nil
						end
					end
					next if x.nil?
					p = Project.new(input_split[1], input_split[2].to_i)
					projects[projects_index] = p
					projects_index += 1
					puts "Added #{p.name} project with target of $#{p.goal}"
				when "back"
					x = valid_length?(input_split[1])
					y = valid_cc?(input_split[3])
					z = 
					contains = false
					unique_cc = true
					next if x.nil?
					next if y.nil?
					unless luhn?(input_split[3])
						puts "ERROR: card fails luhn-10 validation"
						next
					end
					b = Backer.new(input_split[1], input_split[2], input_split[3].to_i, input_split[4].to_i)
					projects.each do |key, value|
						if value.name == input_split[2]
							p = value
							contains = true
						end
					end
					backers.each do |key, value|
						if value.name != b.name && value.cc == b.cc
							puts "ERROR: card has already been added by another user"
							unique_cc = false
							break
						end
					end
					if contains && unique_cc
						p.add(b.amount, b.name)
						backers[backings_index] = b
						puts "#{b.name} backed project #{b.project} for $#{b.amount}"
						puts "#{p.name} has now raised $#{p.raised} of $#{p.goal}"
						backings_index += 1
					elsif contains == false
						puts "ERROR: project does not exist"
					end
				when "list"
					contains = false
					projects.each do |key, value|
						if value.name == input_split[1]
							contains = true
							p = value
							p.backings.each do |key, value|
								puts "-- #{value[:user]} backed for $#{value[:amount]}"
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
					backers.each do |key, value|
						if value.name == name
							contains = true
							puts "-- Backed #{value.project} for $#{value.amount}"
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

def luhn?(cc)
	sum = 0
	cc = cc.to_s
	if cc.length % 2 == 0
		cc = "0" + cc
	end
	digits = cc.split("")
	digits.each_with_index do |n, i|
		if i % 2 == 0
			sum += n.to_i
		else
			double = n.to_i * 2
			double = double.to_s.split("")
			double.each do |d|
				sum += d.to_i
			end
		end
	end
	sum % 10 == 0
end

app = App.new
app.run