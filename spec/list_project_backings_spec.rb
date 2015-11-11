require 'spec_helper'

describe "List Project Backings" do
	before (:each) do
		PROJECTS = []
		BACKINGS = []
		CreateProject.perform("TEST", 300)
		CreateProject.perform("TEST2", 300)
	end

	context "when the project has a backer" do
		before (:each) do
			CreateBacking.perform("USER", PROJECTS[0], "79927398713", "150")
		end
		it "lists the backing" do
		  expect { ListProjectBackings.perform(PROJECTS[0]) }.to output("-- USER backed for $150\nTEST needs $150 more dollars to be successful\n").to_stdout
		end
	end

	context "when the project has no backers" do
		before (:each) do
			CreateBacking.perform("USER", PROJECTS[1], "79927398713", "150")
		end
		it "does not list any backings" do
		  expect { ListProjectBackings.perform(PROJECTS[0]) }.not_to output("-- USER backed for $150\nTEST needs $150 more dollars to be successful\n").to_stdout
		end
	end
end