module Behaviors
  class ListUserBackings < Base
    attr_accessor :name

    def perform
      backings = Database.instance.find_all(:backings) { |v| v[:name] == name }
      if backings == []
        puts "ERROR: user does not exist"
      else
        backings.each { |v| puts "-- Backed #{v.project} for $#{Util.format_cents(v.amount)}" }
      end
    end
  end
end
