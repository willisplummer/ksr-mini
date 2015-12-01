class ListUserBackings
  def self.perform(app, name)
    backings = app.database.get_backings("user", name)
    backings.each { |v| puts "-- Backed #{v.project} for $#{app.format_cents(v.amount)}" }
    puts "ERROR: user does not exist" if backings.nil?
  end
end