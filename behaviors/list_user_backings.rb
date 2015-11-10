class ListUserBackings
	def self.perform(name)
		contains = false
		BACKINGS.each do |v|
			if v.name == name
				contains = true
				puts "-- Backed #{v.project} for $#{v.amount}"
			end
		end
		unless contains
			puts "ERROR: user does not exist"
		end
	end
end