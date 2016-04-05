require 'spec_helper'

describe "Create Backing" do
  before (:each) do
    Database.filepath = 'lib/testdb.json'
    Database.instance.reset!
    Behaviors::CreateProject.perform({ name: "TEST", goal: "300"})
  end

  context "when all is correct" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398713", amount: "150" })
    end
    it "creates a new backing" do
      expect(Database.instance.table(:backings)[0]).not_to be_nil
    end
    it "returns the correct output" do
      expect { Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398713", amount: "150" }) }.to output("USER backed project TEST for $150.00\nTEST has now raised $300.00 of $300\n").to_stdout
    end
  end

  context "when CC is too long" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398713567890123445", amount: "150" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[0]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398713567890123445", amount: "150" }) }.to output("ERROR: this card is invalid\n").to_stdout
    end
  end

  context "when CC contains letters" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "7992T7398713", amount: "150" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[0]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "7992T7398713", amount: "150" }) }.to output("ERROR: this card is invalid\n").to_stdout
    end
  end

  context "when CC does not pass Luhn-10" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398714", amount: "150" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[0]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398714", amount: "150" }) }.to output("ERROR: card fails luhn-10 validation\n").to_stdout
    end
  end

  context "when user name is too short" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USE", project: "TEST", cc: "79927398714", amount: "150" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[0]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "USE", project: "TEST", cc: "79927398714", amount: "150" }) }.to output("ERROR: backer name must be between 4 and 20 characters\n").to_stdout
    end
  end

  context "when user name is too long" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "THISUSERNAMEISWAYTOOLONGINSANELYLONG", project: "TEST", cc: "79927398714", amount: "150" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[0]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "THISUSERNAMEISWAYTOOLONGINSANELYLONG", project: "TEST", cc: "79927398714", amount: "150" }) }.to output("ERROR: backer name must be between 4 and 20 characters\n").to_stdout
    end
  end

  context "when credit card has been used by another backer" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USER1", project: "TEST", cc: "79927398714", amount: "150" })
      Behaviors::CreateBacking.perform({ name: "USER2", project: "TEST", cc: "79927398714", amount: "150" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[1]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "USER2", project: "TEST", cc: "79927398714", amount: "150" }) }.to output("ERROR: card has already been added by another user\n").to_stdout
    end
  end

  context "when pledge is less than 1" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398714", amount: "0" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[0]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398714", amount: "0" }) }.to output("ERROR: pledge amount invalid; must be at least $1 and can only contain numbers\n").to_stdout
    end
  end

  context "when pledge amount contains non-number characters" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398714", amount: "100$" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[0]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "USER", project: "TEST", cc: "79927398714", amount: "100$" }) }.to output("ERROR: pledge amount invalid; must be at least $1 and can only contain numbers\n").to_stdout
    end
  end

  context "when pledge amount contains cents" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "User1", project: "TEST", cc: "79927398713", amount: "100.25" })
      Behaviors::CreateBacking.perform({ name: "User2", project: "TEST", cc: "49927398716", amount: "35.50" })
    end
    it "adds them to the project's raised funds" do
      expect(Database.instance.table(:projects)[0].raised).to eq(135.75)
    end
  end

  context "when pledge amount contains three decimal places" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "User", project: "TEST", cc: "79927398713", amount: "100.123" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[0]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "User", project: "TEST", cc: "79927398713", amount: "100.123" }) }.to output("ERROR: pledge amount contains too many decimal places\n").to_stdout
    end
  end

  context "when project does not exist" do
    before (:each) do
      Behaviors::CreateBacking.perform({ name: "User", project: "TEST1", cc: "79927398713", amount: "100" })
    end
    it "does not create a new backing" do
      expect(Database.instance.table(:backings)[0]).to be_nil
    end
    it "returns the correct error message" do
      expect { Behaviors::CreateBacking.perform({ name: "User", project: "TEST1", cc: "79927398713", amount: "100" }) }.to output("ERROR: project does not exist\n").to_stdout
    end
  end
end
