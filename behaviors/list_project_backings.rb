class ListProjectBackings
	def self.perform(project)
		if App.project_exists?(project)
			BACKINGS.each do |v|
				if v.project == project
					puts "-- #{v.name} backed for $#{App.format_cents(v.amount)}"
				end
			end
			App.get_project(project).successful?
		end
	end
end