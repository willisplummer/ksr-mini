class Project
	attr_accessor :name, :goal, :raised, :backings
	def initialize(attributes = {})
		attributes.each do |k, v|
			send("#{k}=", v)
		end
		@raised = 0
		@backings = []
	end

	def add(pledge, name)
		@raised += pledge
		@backings << { user: name, amount: pledge }
	end

	def successful?
		if @raised >= @goal.to_i
			puts "#{@name} is successful!"
			true
		else
			puts "#{@name} needs $#{App.format_cents(@goal.to_i - @raised)} more dollars to be successful"
			false
		end
	end
end