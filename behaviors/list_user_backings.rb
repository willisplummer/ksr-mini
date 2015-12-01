class ListUserBackings
  def self.perform(app, name)
    backings = app.database.get_backings("user", name)
    puts "ERROR: user does not exist" if backings == []
    backings.each { |v| puts "-- Backed #{v.project} for $#{App.format_cents(v.amount)}" }
  end
end