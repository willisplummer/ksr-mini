class Backing
	attr_accessor :name, :project, :cc, :amount
	def initialize(attributes = {})
		attributes.each do |k, v|
			send("#{k}=", v)
		end
	end
end