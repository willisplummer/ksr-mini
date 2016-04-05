require 'spec_helper'

describe "List Project Backings" do
  before (:each) do
    Database.filepath = 'lib/testdb.json'
    Database.instance.reset!
    Behaviors::CreateProject.perform({ name: "TEST1", goal: "300"})
    Behaviors::CreateProject.perform({ name: "TEST2", goal: "300"})
  end

  context "when the project has a backer" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USER", project: "TEST1", cc: "79927398713", amount: "150" })
    end
    it "lists the backing" do
      expect { Behaviors::ListProjectBackings.perform({ project: "TEST1" }) }.to output("-- USER backed for $150.00\nTEST1 needs $150.00 more dollars to be successful\n").to_stdout
    end
  end

  context "when the project has no backers" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USER", project: "TEST2", cc: "79927398713", amount: "150" })
    end
    it "does not list any backings" do
      expect { Behaviors::ListProjectBackings.perform({ project: "TEST1" }) }.to output("TEST1 does not have any backings yet\n").to_stdout
    end
  end

  context "when the project does not exist" do
    it "returns the correct error message" do
      expect { Behaviors::ListProjectBackings.perform({ project: "TEST3" }) }.to output("ERROR: project does not exist\n").to_stdout
    end
  end
end
