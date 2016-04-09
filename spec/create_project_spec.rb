require 'spec_helper'

describe "Create Project Behavior" do
  before (:each) do
    Database.filepath = 'lib/testdb.json'
    Database.reset!
  end

  context "When Project name is valid length" do
    before (:each) do
      Behaviors::CreateProject.perform({ name: "TEST", goal: "300"})
    end

    it "saves the Project in the database" do
      expect(Database.instance.table(:projects)[0]).not_to be_nil
    end
  end

  context "When Project name is too short" do
    before (:each) do
      Behaviors::CreateProject.perform({ name: "TE", goal: "300"})
    end

    it "does not save the Project" do
      expect(Database.instance.table(:projects)[0]).to be_nil
    end
  end

  context "when project name is too long" do
    before (:each) do
      Behaviors::CreateProject.perform({ name: "TESTOFTHISNAMEISWAYTOOLONG", goal: "300"})
    end

    it "does not save the Project" do
      expect(Database.instance.table(:projects)[0]).to be_nil
    end
  end

  context "when project name is taken" do
    before (:each) do
      Behaviors::CreateProject.perform({ name: "TEST", goal: "300"})
      Behaviors::CreateProject.perform({ name: "TEST", goal: "300"})
    end

    it "does not save the duplicate Project" do
      expect(Database.instance.table(:projects)[1]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateProject.perform({ name: "TEST", goal: "300"}) }.to output("ERROR: project name already taken\n").to_stdout
    end
  end
end
