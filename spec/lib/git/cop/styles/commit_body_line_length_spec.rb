# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitBodyLineLength do
  let(:body_lines) { ["Curabitur eleifend wisi iaculis ipsum."] }
  let(:commit) { object_double Git::Cop::Kit::Commit.new(sha: "1"), body_lines: body_lines }
  let(:length) { 72 }
  let(:settings) { {enabled: true, length: length} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_body_line_length)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Body Line Length")
    end
  end

  describe "#valid?" do
    context "when valid" do
      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "when invalid (single line)" do
      let :body_lines do
        ["Pellentque morbi-trist sentus et netus et malesuada fames ac turpis egest."]
      end

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "when invalid (multiple lines)" do
      let :body_lines do
        [
          "- Curabitur eleifend wisi iaculis ipsum.",
          "- Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante.",
          "- Donec eu_libero sit amet quam egestas semper. Aenean ultricies mi vitae est."
        ]
      end

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
      let(:length) { 55 }
      let :body_lines do
        [
          "- Curabitur eleifend wisi iaculis ipsum.",
          "- Vestibulum tortor quam, feugiat vitae, ultricies eget bon.",
          "- Donec eu_libero sit amet quam egestas semper. Aenean ultr."
        ]
      end
      let(:issue) { subject.issue }

      it "answers issue label" do
        expect(issue[:label]).to eq("Invalid line length.")
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Use #{length} characters or less per line.")
      end

      it "answers issue lines" do
        expect(issue[:lines]).to eq(
          [
            {number: 2, content: "- Vestibulum tortor quam, feugiat vitae, ultricies eget bon."},
            {number: 3, content: "- Donec eu_libero sit amet quam egestas semper. Aenean ultr."}
          ]
        )
      end
    end
  end
end
