# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitAuthorNameParts do
  let(:name) { "Example Tester" }
  let(:commit) { object_double Git::Cop::Commit.new(sha: "1"), author_name: name }
  let(:minimum) { 2 }
  let(:settings) { {enabled: true, minimum: minimum} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_author_name_parts)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Author Name Parts")
    end
  end

  describe "#valid?" do
    context "when exactly minimum" do
      let(:name) { "Example" }
      let(:minimum) { 1 }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "when greater than minimum" do
      let(:name) { "Example Test Tester" }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "when less than minimum" do
      let(:name) { "Example" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe "#error" do
    context "when valid" do
      it "answers empty string" do
        expect(subject.error).to eq("")
      end
    end

    context "when invalid" do
      let(:name) { "Example" }
      it "answers error message" do
        message = %(Invalid name: "Example". Detected 1 out of 2 parts required.)
        expect(subject.error).to eq(message)
      end
    end
  end
end
