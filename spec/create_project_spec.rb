require 'spec_helper'

describe "Create Project Behavior" do
	before (:each) do
		PROJECTS = []
	end

	context "When Project name is valid length" do
		before (:each) do
			CreateProject.perform("TEST", "300")
		end

		it "saves the Project in PROJECTS" do
			expect(PROJECTS[0]).not_to be_nil
		end
	end

	context "When Project name is too short" do
		before (:each) do
			CreateProject.perform("TE", "300")
		end

		it "does not save the Project in PROJECTS" do
			expect(PROJECTS[0]).to be_nil
		end
	end

	context "When Project name is too long" do
		before (:each) do
			CreateProject.perform("TESTOFTHISWAYTOOLONGNAME", "300")
		end

		it "does not save the Project in PROJECTS" do
			expect(PROJECTS[0]).to be_nil
		end
	end
end