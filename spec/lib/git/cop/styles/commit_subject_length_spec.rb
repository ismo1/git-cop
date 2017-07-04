# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitSubjectLength do
  let(:content) { "Added test subject." }
  let(:commit) { object_double Git::Cop::Kit::Commit.new(sha: "1"), subject: content }
  let(:length) { 25 }
  let(:settings) { {enabled: true, length: length} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_subject_length)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Subject Length")
    end
  end

  describe "#valid?" do
    context "when valid" do
      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with invalid content" do
      let(:content) { "Curabitur eleifend wisi iaculis ipsum." }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with invalid length" do
      let(:length) { 10 }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe "#issue" do
    context "when valid" do
      it "answers empty string" do
        expect(subject.issue).to eq("")
      end
    end

    context "when invalid" do
      let(:length) { 10 }

      it "answers issue" do
        expect(subject.issue).to eq("Invalid length. Use 10 characters or less.")
      end
    end
  end
end
