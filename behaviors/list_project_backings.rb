class ListProjectBackings
	def self.perform(project)
		if App.project_exists?(project)
			project = App.get_project(project)
			project.backings.each do |v|
				puts "-- #{v[:user]} backed for $#{App.format_cents(v[:amount])}"
			end
			project.successful?
		end
	end
end