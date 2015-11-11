require 'spec_helper'

describe "List User Backings" do
	before (:each) do
		PROJECTS = []
		BACKINGS = []
		CreateProject.perform("TEST", 300)
		CreateProject.perform("TEST2", 300)
		CreateBacking.perform("USER", PROJECTS[0], "79927398713", "150")
		CreateBacking.perform("USER", PROJECTS[1], "79927398713", "200")
	end

	context "when the user has backed projects" do
		it "lists the backings" do
		  expect { ListUserBackings.perform("USER") }.to output("-- Backed TEST for $150\n-- Backed TEST2 for $200\n").to_stdout
		end
	end

	context "when the user has not backed any projects" do
		it "does not list any backings" do
		  expect { ListUserBackings.perform("USER2") }.to output("ERROR: user does not exist\n").to_stdout
		end
	end
end