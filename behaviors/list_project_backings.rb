class ListProjectBackings
  def self.perform(app, project)
    backings = app.database.get_backings("project", project)
    backings.each { |v| puts "-- #{v.name} backed for $#{app.format_cents(v.amount)}" }
    backings == [] ? (puts "ERROR: project does not exist") : app.database.search("project", project).successful?
  end
end