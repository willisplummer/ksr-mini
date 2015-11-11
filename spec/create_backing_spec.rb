require 'spec_helper'

describe "Create Backing" do
	before (:each) do
		PROJECTS = []
		BACKINGS = []
		CreateProject.perform("TEST", 300)
	end

	context "when all is correct" do
		before (:each) do
			CreateBacking.perform("USER", "TEST", "79927398713", "150")
		end
		it "creates a new backing" do
			expect(BACKINGS[0]).not_to be_nil 
		end
	end

	context "when CC is too long" do
		before (:each) do
			CreateBacking.perform("USER", "TEST", "79927398713567890123445", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when CC contains letters" do
		before (:each) do
			CreateBacking.perform("USER", "TEST", "7992T7398713", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when CC does not pass Luhn-10" do
		before (:each) do
			CreateBacking.perform("USER", "TEST", "79927398714", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when user name is too short" do
		before (:each) do
			CreateBacking.perform("USE", "TEST", "79927398713", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when user name is too long" do
		before (:each) do
			CreateBacking.perform("THISUSERNAMEISWAYTOOLONGINSANELYLONG", "TEST", "79927398713", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when credit card has been used by another backer" do
		before (:each) do
			CreateBacking.perform("USER1", "TEST", "79927398713", "150")
			CreateBacking.perform("USER2", "TEST", "79927398713", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[1]).to be_nil 
		end
	end

	context "when pledge is less than 0" do
		before (:each) do
			CreateBacking.perform("User", "TEST", "79927398713", "-10")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when pledge is 0" do
		before (:each) do
			CreateBacking.perform("User", "TEST", "79927398713", "0")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when pledge amount contains non-number characters" do
		before (:each) do
			CreateBacking.perform("User", "TEST", "79927398713", "100$")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when pledge amount contains cents" do
		before (:each) do
			CreateBacking.perform("User", "TEST", "79927398713", "100.25")
			CreateBacking.perform("User2", "TEST", "49927398716", "35.50")
		end
		it "adds them to the project's raised funds" do
			expect(PROJECTS[0].raised).to eq(135.75) 
		end
	end

	context "when pledge amount contains three decimal places" do
		before (:each) do
			CreateBacking.perform("User", "TEST", "79927398713", "100.123")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end
end