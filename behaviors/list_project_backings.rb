class ListProjectBackings
	def self.perform(project)
		project.backings.each do |v|
			puts "-- #{v[:user]} backed for $#{v[:amount]}"
		end
		project.successful?
	end
end