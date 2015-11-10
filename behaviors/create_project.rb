class CreateProject
	def self.perform(name, goal)
		if valid_length?(name) && name_not_taken?(name)
			p = Project.new({ name: name, goal: goal.to_i })
			PROJECTS << p
			puts "Added #{p.name} project with target of $#{p.goal}"
		end
	end

	def self.name_not_taken?(name)
		not_taken = true
		PROJECTS.each do |v|
			if v.name == name
				puts "ERROR: project name already taken"
				not_taken = false
			end
		end
		return not_taken
	end

	def self.valid_length?(input)
		if 4 <= input.length && input.length <= 20
			true
		else
			puts "ERROR: project name must be between 4 and 20 characters"
			false
		end
	end
end