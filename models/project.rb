module Models
  class Project < Base
    TABLE = :projects
    VALIDATIONS = {
      valid_length?: "ERROR: project name must be between 4 and 20 characters", 
      name_not_taken?: "ERROR: project name already taken"
    }

    attr_accessor :goal, :raised, :backings

    def raised(db)
      raised = db
        .find_all(:backings) { |v| v.project == name }
        .inject(0) { |sum, backing| sum + backing.amount.to_f }
    end

    def successful?
      if raised >= goal.to_i
        puts "#{@name} is successful!"
        true
      else
        puts "#{@name} needs $#{App.format_cents(@goal.to_i - @raised)} more dollars to be successful"
        false
      end
    end

# validations

    def name_not_taken?
      match = db.find(:projects) { |v| v.name == name }
      match.nil?
    end

    def valid_length?
      4 <= name.length && name.length <= 20
    end
  end
end
