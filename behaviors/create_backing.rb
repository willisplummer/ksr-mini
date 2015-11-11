class CreateBacking
	def self.perform(name, project, cc, amount)
		if valid_length?(name) && valid_cc?(cc) && luhn?(cc) && unique_cc?(name, cc) && pledge_valid?(amount) && valid_cents(amount)
			b = Backing.new({ name: name, project: project.name, cc: cc.to_i, amount: amount.to_f })
			project.add(amount.to_f, name)
			BACKINGS << b
			puts "#{b.name} backed project #{b.project} for $#{b.amount}"
			puts "#{project.name} has now raised $#{project.raised} of $#{project.goal}"
		end
	end

	def self.valid_length?(input)
		unless 4 <= input.length && input.length <= 20
			puts "ERROR: backer name must be between 4 and 20 characters"
			return false
		end
		true
	end

	def self.pledge_valid?(amount)
		unless amount.to_i > 0 && amount.sub(".", "") == amount.sub(".", "").to_i.to_s
			puts "Error: pledge amount invalid must be greater than $0 and can only contain numbers"
			return false
		end
		true
	end

	def self.valid_cents(amount)
		parts = amount.split(".")
		if !parts[1].nil? && parts[1].length > 2
			puts "Error: pledge amount contains too many decimal places"
			return false
		end
		true
	end

	def self.valid_cc?(input)
		if input.length <= 19 && input == input.to_i.to_s
			true
		else
			puts "ERROR: this card is invalid"
			false
		end
	end

	def self.unique_cc?(name, cc)
		BACKINGS.each do |v|
			if v.name != name && v.cc == cc.to_i
				puts "ERROR: card has already been added by another user"
				return false
			end
		end
	end

	def self.luhn?(cc)
		sum = 0
		cc = cc.to_s

		if cc.length % 2 == 0
			cc = "0" + cc
		end
		digits = cc.split("")

		digits.each_with_index do |n, i|
			if i % 2 == 0
				sum += n.to_i
			else
				double = n.to_i * 2
				double = double.to_s.split("")
				double.each do |d|
					sum += d.to_i
				end
			end
		end

		if sum % 10 == 0
			true
		else 
			puts "ERROR: card fails luhn-10 validation"
			false
		end

	end	
end