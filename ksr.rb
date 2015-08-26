class Project
	attr_reader :name, :target_amount, :backers, :current_amount
	def initialize(name, target_amount)
		@name = name
		@target_amount = target_amount
		@backers = {}
		@current_amount = 0
	end
	def back(given_name, backing_amount)
		@backers[given_name.capitalize] = backing_amount
	end
	def list
		@backers.each { |key, value| puts "#{key} pledged #{value} dollars"}
	end
end

test = Project.new("Exploding Kittens", 500)
test.back("tom", 50)
test.back("emily", 3)

puts "The project #{test.name} is trying to raise #{test.target_amount} dollars."
puts "#{test.name} currently has #{test.backers.count} backers and #{test.current_amount} dollars raised."
puts "The following people have supported #{test.name}:"
test.list

