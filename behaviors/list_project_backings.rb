module Behaviors
  class ListProjectBackings < Base
    attr_accessor :project

    def perform
      project = db.table(:projects).find { |v| v.name == project } # for some reason this isn't workign
      print_backings if project_exists?
    end

    def project_exists?
      if project.nil?
        puts "ERROR: project does not exist"
        false
      else
        true
      end
    end

    def print_backings
      backings = db.table(:backings).find_all { |v| v.project == project.name }
      if backings == []
        puts "#{@project.name} does not have any backings yet"
      else
        backings.each { |v| puts "-- #{v.name} backed for $#{Util.format_cents(v.amount)}" }
        project.successful?
      end
    end
  end
end
