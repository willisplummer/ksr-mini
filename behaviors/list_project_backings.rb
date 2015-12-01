class ListProjectBackings
  def self.perform(app, project)
    p = app.database.search("project", project) 
    unless p
      puts "ERROR: project does not exist"
      return
    end 
    backings = app.database.get_backings("project", project)
    backings.each { |v| puts "-- #{v.name} backed for $#{App.format_cents(v.amount)}" }
    backings == [] ? (puts "#{project} does not have any backings yet") : p.successful?
  end
end