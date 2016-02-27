module Models
  class Backing < Base

    TABLE = :backings
    VALIDATIONS = {
      valid_length?: "ERROR: backer name must be between 4 and 20 characters",
      project_exists?: "ERROR: project does not exist",
      valid_cc?: "ERROR: this card is invalid",
      unique_cc?: "ERROR: card has already been added by another user",
      luhn?: "ERROR: card fails luhn-10 validation",
      valid_pledge?: "ERROR: pledge amount invalid; must be at least $1 and can only contain numbers",
      valid_cents?: "ERROR: pledge amount contains too many decimal places"
    }

    attr_accessor :project, :cc, :amount

# validations

    def project_exists?
      match = db.table(:projects).find { |v| v.name == project }
      !match.nil?
    end

    def valid_length?
      4 <= name.length && name.length <= 20
    end

    def valid_pledge?
      amount.to_i >= 1 && amount.sub(".", "") == amount.sub(".", "").to_i.to_s
    end

    def valid_cents?
      parts = amount.split(".")
      parts[1].nil? || parts[1].length <= 2
    end

    def valid_cc?
      cc.length <= 19 && cc == cc.to_i.to_s
    end

    def unique_cc?
      match = db.table(:backings).find { |v| v.cc.to_s == cc.to_s && v.name != name }
      match.nil?
    end

    def luhn?
      sum = 0

      cc = cc.to_s
      cc = "0#{cc}" if cc.length % 2 == 0

      digits = cc.split("")
      digits.each_with_index do |n, i|
        if i % 2 == 0
          sum += n.to_i
        else
          double = n.to_i * 2
          double = double.to_s.split("")
          double.each { |d| sum += d.to_i }
        end
      end

      sum % 10 == 0
    end
  end
end
