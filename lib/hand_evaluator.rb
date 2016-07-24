require_relative "check_hand_rank.rb"
require_relative "check_hand_suit.rb"
require_relative "tie_breaker.rb"

class HandEvaluator
  def return_stronger_hand(hand1, hand2)
    hand_strengths = ["high card", "one pair", "two pair", "three of a kind", "straight", "flush", "full house", "four of a kind", "straight flush"] 
    
    strengths1 = determine_hand_strength(hand1)
    strengths2 = determine_hand_strength(hand2)
    if hand_strengths.index(strengths1[0]) > hand_strengths.index(strengths2[0])
      return hand1
    elsif hand_strengths.index(strengths2[0]) > hand_strengths.index(strengths1[0])
      return hand2
    else
      tie_result = TieBreaker.winner(strengths1, strengths2)
      if tie_result == "1"
        return hand1
      elsif tie_result == "2"
        return hand2
      elsif tie_result == "tie"
        return "Tie!... split the pot."
      end
    end
  end

  
  def create_rank_array(hand)
    rank_separator(rank_suit_separator(hand))
  end

  def create_suit_array(hand)
    suit_separator(rank_suit_separator(hand))
  end

  def determine_hand_strength(hand)
    strengths = determine_rank_strength(create_rank_array(hand))
    if determine_suit_strength(create_suit_array(hand)) == "flush" && strengths[0] == "straight"
      strengths[1] = "straight flush"
    elsif determine_suit_strength(create_suit_array(hand)) == "flush"
      strengths[1] = "flush"
    elsif strengths[0] == "straight"
      strengths[1] = "straight"
    end
    strengths.shift
    strengths
  end

  def determine_suit_strength(suits)
    CheckHandSuit.new.same_suit(suits)
  end

  def determine_rank_strength(ranks)
    hand_rank = CheckHandRank.new(ranks) 
    straight = hand_rank.consecutive_rank(hand_rank.hand_ranks_sorted_by_num) 
    other = hand_rank.check_rank_hand_strength
    strengths = [straight, other, hand_rank.hand_ranks_sorted_by_num]
  end

  
  def rank_suit_separator(hand)
    hand.collect { |card| card.scan(/./) }
  end

  def rank_separator(rank_suit_separated_hand)
    rank_suit_separated_hand.collect { |card| card[0] }
  end

  def suit_separator(rank_suit_separated_hand)
    rank_suit_separated_hand.collect { |card| card[1] }
  end
end
