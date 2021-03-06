module Models
  class Project < Base
    TABLE = :projects
    VALIDATIONS = {
      valid_length?: "ERROR: project name must be between 4 and 20 characters",
      name_not_taken?: "ERROR: project name already taken"
    }
    VALID_ATTRIBUTES = [:goal, :name]

    attr_accessor :goal, :raised

    def raised
      raised = Database.instance
        .find_all(:backings) { |v| v[:project] == name }
        .inject(0) { |sum, backing| sum + backing.amount.to_f }
    end

    def successful?
      if raised >= goal.to_i
        puts "#{name} is successful!"
        true
      else
        puts "#{name} needs $#{Util.format_cents(goal.to_i - raised)} more dollars to be successful"
        false
      end
    end

# validations

    def name_not_taken?
      match = Database.instance.find(:projects) { |v| v[:name] == name }
      match.nil?
    end

    def valid_length?
      4 <= name.length && name.length <= 20
    end
  end
end
