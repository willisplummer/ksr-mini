class ListProjectBackings
	def self.perform(project)
		if App.project_exists?(project)
			BACKINGS.each { |v| puts "-- #{v.name} backed for $#{App.format_cents(v.amount)}" if v.project == project }
			App.get_project(project).successful?
		end
	end
end