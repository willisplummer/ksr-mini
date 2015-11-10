class ListProjectBackings
	def self.perform(project)
		p = get_project(project)
		unless p.nil?
			p.backings.each do |v|
				puts "-- #{v[:user]} backed for $#{v[:amount]}"
			end
			p.successful?
		end
	end

	def self.get_project(project)
		PROJECTS.each do |v|
			if v.name == project
				return v
			end
		end	
		puts "ERROR: project does not exist"
		return nil
	end
end