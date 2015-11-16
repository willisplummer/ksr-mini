class ListUserBackings
  def self.perform(name)
    contains = false
    BACKINGS.each do |v|
      if v.name == name
        contains = true
        puts "-- Backed #{v.project} for $#{App.format_cents(v.amount)}"
      end
    end
    puts "ERROR: user does not exist" unless contains
  end
end