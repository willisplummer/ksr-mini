require 'spec_helper'

describe "Create Backing" do
	before (:each) do
		PROJECTS = []
		BACKINGS = []
		CreateProject.perform("TEST", 300)
	end

	context "when all is correct" do
		before (:each) do
			CreateBacking.perform("USER", PROJECTS[0], "79927398713", "150")
		end
		it "creates a new backing" do
			expect(BACKINGS[0]).not_to be_nil 
		end
	end

	context "when CC is too long" do
		before (:each) do
			CreateBacking.perform("USER", PROJECTS[0], "79927398713567890123445", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when CC contains letters" do
		before (:each) do
			CreateBacking.perform("USER", PROJECTS[0], "7992T7398713", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when CC does not pass Luhn-10" do
		before (:each) do
			CreateBacking.perform("USER", PROJECTS[0], "79927398714", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when user name is too short" do
		before (:each) do
			CreateBacking.perform("USE", PROJECTS[0], "79927398713", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when user name is too long" do
		before (:each) do
			CreateBacking.perform("THISUSERNAMEISWAYTOOLONGINSANELYLONG", PROJECTS[0], "79927398713", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[0]).to be_nil 
		end
	end

	context "when credit card has been used by another backer" do
		before (:each) do
			CreateBacking.perform("USER1", PROJECTS[0], "79927398713", "150")
			CreateBacking.perform("USER2", PROJECTS[0], "79927398713", "150")
		end
		it "does not create a new backing" do
			expect(BACKINGS[1]).to be_nil 
		end
	end
end