require 'spec_helper'

describe "Backing" do
	subject do
		Project.new({ name: "TEST_PROJECT", goal: "500" })
	end

	describe "instance methods" do
		describe "#name" do
			it "returns the correct value" do
				expect(subject.name).to eq("TEST_PROJECT")
			end
		end
		describe "#goal" do
			it "returns the correct value" do
				expect(subject.goal).to eq("500")
			end
		end
		describe "#raised" do
			it "returns the correct value" do
				expect(subject.raised).to eq(0)
			end
		end
		describe "#backings" do
			it "returns the correct value" do
				expect(subject.backings).to eq([])
			end
		end
	end


	describe "add method" do
		before  :each do
			subject.add(500, "JOE")
		end
		describe "#raised" do
			it "returns the correct value" do
				expect(subject.raised).to eq(500)
			end
		end
		describe "#backings" do
			it "returns the correct value" do
				expect(subject.backings).to eq([ {user: "JOE", amount: 500} ])
			end
		end
		
		# describe "#successful?" do
		# 	it "knows the project has succeeded" do
		# 		expect(subject.successful?).to be true
		# 	end
		# end
	end

	
end