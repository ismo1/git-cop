# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Commit, :git_repo do
  let(:sha) { Dir.chdir(git_repo_dir) { `git log --pretty=format:%H -1` } }
  subject { Dir.chdir(git_repo_dir) { described_class.new sha: sha } }

  before do
    Dir.chdir git_repo_dir do
      `touch test.md`
      `git add --all .`
      `git commit -m "Added test documentation." -m "- Necessary for testing purposes."`
    end
  end

  describe ".pattern" do
    it "answers pretty format pattern for all known formats" do
      expect(described_class.pattern).to eq(
        "<sha>%H</sha>%n" \
        "<author_name>%an</author_name>%n" \
        "<author_email>%ae</author_email>%n" \
        "<subject>%s</subject>%n" \
        "<body>%b</body>%n" \
        "<raw_body>%B</raw_body>%n"
      )
    end
  end

  describe "#initialize" do
    context "with invalid SHA" do
      let(:sha) { "bogus" }

      before do
        Dir.chdir git_repo_dir do
          FileUtils.rm_f ".git"
          `git init`
        end
      end

      it "answers empty string for all data methods" do
        described_class::FORMATS.keys.each do |key|
          expect(subject.public_send(key)).to eq("")
        end
      end
    end
  end

  describe "#sha" do
    it "answers SHA" do
      expect(subject.sha).to match(/[0-9a-f]{40}/)
    end
  end

  describe "#author_name" do
    it "answers author name" do
      expect(subject.author_name).to eq("Testy Tester")
    end
  end

  describe "#author_email" do
    it "answers author email" do
      expect(subject.author_email).to eq("tester@example.com")
    end
  end

  describe "#subject" do
    it "answers subject" do
      expect(subject.subject).to eq("Added test documentation.")
    end
  end

  describe "#body" do
    it "answers body with single line" do
      expect(subject.body).to eq("- Necessary for testing purposes.\n")
    end

    context "with multiple lines" do
      let :commit_message do
        "Added multi text file.\n\n" \
        "- Necessary for multi-line test.\n" \
        "- An extra bullet point.\n"
      end

      before do
        Dir.chdir git_repo_dir do
          `touch multi.txt`
          `git add --all .`
          `git commit --message $'#{commit_message}'`
        end
      end

      it "answers body with multiple lines" do
        body = "- Necessary for multi-line test.\n- An extra bullet point.\n"
        expect(subject.body).to eq(body)
      end
    end
  end

  describe "#raw_body" do
    it "answers raw body" do
      content = "Added test documentation.\n\n- Necessary for testing purposes.\n"
      expect(subject.raw_body).to eq(content)
    end
  end

  describe "#respond_to?" do
    it "answers true for data methods" do
      described_class::FORMATS.keys.each do |key|
        expect(subject.respond_to?(key)).to eq(true)
      end
    end

    it "answers false for invalid methods" do
      expect(subject.respond_to?(:bogus)).to eq(false)
    end
  end
end