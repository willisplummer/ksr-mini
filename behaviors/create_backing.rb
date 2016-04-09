module Behaviors
  class CreateBacking < Base
    attr_accessor :name, :project, :cc, :amount

    def perform
      backing = Models::Backing.new(name: name, project: project, cc: cc, amount: amount)
      if backing.save
        p = Database.instance.find(:projects) { |v| v[:name] == project }
        puts "#{name} backed project #{p.name} for $#{Util.format_cents(amount)}"
        puts "#{p.name} has now raised $#{Util.format_cents(p.raised)} of $#{p.goal}"
      end
    end
  end
end
