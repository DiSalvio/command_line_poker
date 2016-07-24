require_relative "spec_helper"
require_relative "../lib/check_hand_rank"

describe CheckHandRank do
  describe "#consecutive_rank" do
#    straight_array = %w(2 3 4 5 6)
#    no_straight_array = %w(3 5 7 9 J)
    check_hand_rank = ->(rank_cards) { CheckHandRank.new(rank_cards).consecutive_rank(CheckHandRank.new(rank_cards).hand_ranks_sorted_by_num) }
    it "checks for a straight but finds non consecutive cards" do
#      c = CheckHandRank.new(no_straight_array)
      expect(check_hand_rank.call(%w(3 5 7 9 J))).to be nil
    end

    it "checks for a straight and finds one" do
#      c = CheckHandRank.new(straight_array)
      expect(check_hand_rank.call(%w(2 3 4 5 6))).to eq "straight"
    end
  end

  describe "#same_rank" do
    check_hand = ->(cards) { CheckHandRank.new(cards).same_rank }
    it "Finds full house" do
      expect(check_hand.call(%w(2 3 3 2 3))).to eq [1, 1, 1, 0, 0]
    end
    it "Finds four of a kind" do
      expect(check_hand.call(%w(7 4 4 4 4))).to eq [2, 2, 2, 2]
    end
    it "Finds two pair" do
      expect(check_hand.call(%w(Q 3 3 9 9))).to eq [7, 7, 1, 1]
    end
    it "Finds three of a kind" do
      expect(check_hand.call(%w(A 3 3 3 9))).to eq [1, 1, 1]
    end
    it "Finds one pair" do
      expect(check_hand.call(%w(2 3 3 4 9))).to eq [1, 1]
    end
    it "Only finds high card" do
      expect(check_hand.call(%w(J 3 9 4 K))).to eq []
    end
  end

  describe "#check_rank_hand_strength" do
    check_hand_r_s = ->(cards) { CheckHandRank.new(cards).check_rank_hand_strength }
    it "Finds full house" do
      expect(check_hand_r_s.call(%w(2 3 3 2 3))).to eq "full house" 
    end
    it "Finds four of a kind" do
      expect(check_hand_r_s.call(%w(7 4 4 4 4))).to eq "four of a kind" 
    end
    it "Finds two pair" do
      expect(check_hand_r_s.call(%w(Q 3 3 9 9))).to eq "two pair"
    end
    it "Finds three of a kind" do
      expect(check_hand_r_s.call(%w(A 3 3 3 9))).to eq "three of a kind"
    end
    it "Finds one pair" do
      expect(check_hand_r_s.call(%w(2 3 3 4 9))).to eq "one pair" 
    end
    it "Only finds high card" do
      expect(check_hand_r_s.call(%w(J 3 9 4 K))).to eq "high card"
    end

  end    
end
