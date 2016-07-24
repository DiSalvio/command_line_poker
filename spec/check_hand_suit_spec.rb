require_relative "spec_helper"
require_relative "../lib/check_hand_suit.rb"

describe CheckHandSuit do
  describe "#same_suit" do
    no_flush_suit_array = %w(S S D C S)
    flush_suit_array = %w(C C C C C)
    it "checks for a flush but finds different suits" do
      expect(CheckHandSuit.new.same_suit(no_flush_suit_array)).to eq nil
    end

    it "checks for a flush and finds one" do
      expect(CheckHandSuit.new.same_suit(flush_suit_array)).to eq "flush"
    end
  end
end
