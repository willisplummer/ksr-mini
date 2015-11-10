require 'spec_helper'

describe App do
	describe "project" do
		it "takes three parameters and returns a book object" do
			@project = Project.new("name", 300)
			@project.stub!(:gets) { "project name 300" }
			@project.should be_an_instance_of Project
		end
	end
end