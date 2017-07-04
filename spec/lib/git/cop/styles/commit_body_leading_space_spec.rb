# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyLeadingSpace do
  let(:raw_body) { "Added documentation.\n\n- Necessary for testing purposes.\n" }
  let(:commit) { object_double Git::Cop::Kit::Commit.new(sha: "1"), raw_body: raw_body }
  let(:settings) { {enabled: true} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_leading_space)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Leading Space")
    end
  end

  describe "#valid?" do
    context "when valid" do
      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with subject only" do
      let(:raw_body) { "A commit message." }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with no space between subject and body" do
      let(:raw_body) { "Subject\nBody\n" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with subject and no body" do
      let(:raw_body) { "A test subject.\n\n" }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with no content" do
      let(:raw_body) { "" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe "#issue" do
    context "when valid" do
      it "answers empty hash" do
        expect(subject.issue).to eq({})
      end
    end

    context "when invalid" do
      let(:raw_body) { "A commit message.\nWithout leading space." }
      let(:issue) { subject.issue }

      it "answers issue label" do
        expect(issue[:label]).to eq("Invalid leading space.")
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Use space between subject and body.")
      end
    end
  end
end
