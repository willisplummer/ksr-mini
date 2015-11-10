require 'spec_helper'

describe "Backing" do
	subject do
		Backing.new({ name: "WILLIS", project: "TEST", cc: "1234567890", amount: "100"})
	end

	describe "instance methods" do
		describe "#cc" do
			it "returns the correct value" do
				expect(subject.cc).to eq("1234567890")
			end
		end
		describe "#name" do
			it "returns the correct value" do
				expect(subject.name).to eq("WILLIS")
			end
		end
		describe "#project" do
			it "returns the correct value" do
				expect(subject.project).to eq("TEST")
			end
		end
		describe "#amount" do
			it "returns the correct value" do
				expect(subject.amount).to eq("100")
			end
		end

	end
end