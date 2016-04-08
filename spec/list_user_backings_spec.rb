require 'spec_helper'

describe "List User Backings" do
  before (:each) do
    Database.filepath = 'lib/testdb.json'
    Database.reset!
    Behaviors::CreateProject.perform({ name: "TEST1", goal: "300"})
    Behaviors::CreateProject.perform({ name: "TEST2", goal: "300"})
    Behaviors::CreateBacking.perform({ name: "USER", project: "TEST1", cc: "79927398713", amount: "150" })
    Behaviors::CreateBacking.perform({ name: "USER", project: "TEST2", cc: "79927398713", amount: "200" })
  end

  context "when the user has backed projects" do
    it "lists the backings" do
      expect { Behaviors::ListUserBackings.perform(name: "USER") }.to output("-- Backed TEST1 for $150.00\n-- Backed TEST2 for $200.00\n").to_stdout
    end
  end

  context "when the user has not backed any projects" do
    it "does not list any backings" do
      expect { Behaviors::ListUserBackings.perform(name: "USER2") }.to output("ERROR: user does not exist\n").to_stdout
    end
  end
end
