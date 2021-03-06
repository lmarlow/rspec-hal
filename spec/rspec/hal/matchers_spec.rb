require_relative "../../spec_helper"

describe RSpec::Hal::Matchers::Document do
  describe "be_hal" do
    subject(:matcher) { be_hal }

    specify { expect(matcher.matches?(hal_doc)).to be true }
    specify { expect(matcher.matches?("What's HAL?")).to be false }
  end

  describe "be_hal_collection" do
    subject(:matcher) { be_hal_collection }

    specify { expect(matcher.matches?(hal_collection)).to be true }
    specify { expect(matcher.matches?("What's HAL?")).to be false }
    specify { expect(matcher.matches?(hal_doc)).to be false }
  end

  describe "have_property('name')" do
    subject(:matcher) { have_property('name') }

    specify { expect(matcher.matches?(hal_doc)).to be true}
    specify { expect(matcher.matches?("{}")).to be false}
  end

  describe "have_property('name').matching(/ice$/)" do
    subject(:matcher) { have_property('name').matching(/ice$/) }

    specify { expect(matcher.matches?(hal_doc)).to be true}
    specify { expect(matcher.matches?("{}")).to be false}
    specify { expect(matcher.matches?(bob)).to be false}
  end

  describe "have_property('name').matching(end_with('ice'))" do
    subject(:matcher) { have_property('name')
        .matching(RSpec::Matchers::BuiltIn::EndWith.new("ice")) }

    specify { expect(matcher.matches?(hal_doc)).to be true}
    specify { expect(matcher.matches?("{}")).to be false}
    specify { expect(matcher.matches?(bob)).to be false}
  end

  describe "have_property('hobbies').including(a_hash_including('type' => 'sport'))" do
    subject(:matcher) { have_property('hobbies')
        .including(RSpec::Matchers::BuiltIn::Include.new('type' => 'sport')) }
    before do extend described_class end

    specify { expect(matcher.matches?(hal_doc)).to be true}
    specify { expect(matcher.matches?("{}")).to be false}
    specify { expect(matcher.matches?(bob)).to be false}
  end

  describe "have_relation('tag')" do
    subject(:matcher) { have_relation('tag') }

    specify { expect(matcher.matches?(hal_doc)).to be true}
    specify { expect(matcher.matches?("{}")).to be false}
    specify { expect(matcher.matches?(bob)).to be false}
  end


  before do
    extend RSpec::Hal::Matchers::Document
  end

  let(:hal_collection) { <<-HAL }
    { "_embedded": { "item": [
          #{hal_doc}
    ]}}
  HAL
  let(:hal_doc) { <<-HAL }
    { "name": "Alice"
      ,"hobbies": [{"type": "sport", "name": "golf"}]
      ,"_links": {
        "tag": [{ "href": "http://tags.example.com/smart" }]
      }
      ,"_embedded": {
        "http://rel.example.com/boss_of": #{bob}
      }
    }
  HAL
  let(:bob) { <<-HAL }
    { "name": "Bob"
      ,"_links": {
        "self": { "href": "http://example.com/users/42" }
      }
      ,"_embedded": {
      }
    }
  HAL
end
