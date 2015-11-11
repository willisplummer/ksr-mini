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
		before :each do
			subject.add(150, "JOE")
		end

		describe "#raised" do
			it "returns the correct value" do
				expect(subject.raised).to eq(150)
			end
		end
		describe "#backings" do
			it "returns the correct value" do
				expect(subject.backings).to eq([ {user: "JOE", amount: 150} ])
			end
		end
	end


	describe "successful project check" do
		before :each do
			subject.raised = 500
		end

		describe "when raised funding goal" do
			it "returns true" do
				expect(subject.successful?).to eq(true)
			end
		end
	end


	describe "successful check" do
		before :each do
			subject.raised = 300
		end

		describe "when project has not raised funding goal" do
			it "returns false" do
				expect(subject.raised).to eq(300)
				expect(subject.successful?).to eq(false)
			end
		end
	end

	
end