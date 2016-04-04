require 'spec_helper'

describe "Backing" do
  subject do
    Models::Project.new({ name: "TEST_PROJECT", goal: 500 })
  end

  describe "instance methods" do
    describe "#name" do
      it "returns the correct value" do
        expect(subject.name).to eq("TEST_PROJECT")
      end
    end
    describe "#goal" do
      it "returns the correct value" do
        expect(subject.goal).to eq(500)
      end
    end
    describe "#raised" do
      it "returns the correct value" do
        expect(subject.raised).to eq(0)
      end
    end
  end

  describe "successful project check" do
    before :each do
      allow(subject).to receive(:raised) {500}
    end

    describe "when raised funding goal" do
      it "returns true" do
        expect(subject.successful?).to eq(true)
      end
    end
  end


  describe "successful check" do
    before :each do
      allow(subject).to receive(:raised) {400}
    end

    describe "when project has not raised funding goal" do
      it "returns false" do
        expect(subject.successful?).to eq(false)
      end
    end
  end
end
