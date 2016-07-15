require_relative "check_hand_rank.rb"
require_relative "check_hand_suit.rb"

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
      if tie_breaker(strengths1, strengths2) == "1"
        return hand1
      elsif tie_breaker(strengths1, strengths2) == "2"
        return hand2
      elsif tie_breaker(strengths1, strengths2) == "tie"
        return "tie"
      end
    end
  end

  def tie_breaker(strengths1, strengths2)
    case strengths1[0]
      when "straight flush", "straight"
        if strengths1[1][0] > strengths2[1][0]
          return "1"
	elsif strengths2[1][0] > strengths1[1][0]
	  return "2"
	else
	  return "tie"
	end
      when "flush", "high card"
        strengths1[1].zip(strengths2[1]).each do |card|
          if card[0] > card[1]
	    return "1"
	  elsif card[1] > card[0]
	    return "2"
	  elsif card[1] == card[0] && card[0] == strengths[1][4]
	    "tie"
	  end
	end
      when "four of a kind"
        four_rank1 = strengths1[1].group_by { |rank| rank }.select { |rank, cards| cards.size > 3 }.map(&:first)
        four_rank2 = strengths2[1].group_by { |rank| rank }.select { |rank, cards| cards.size > 3 }.map(&:first)
	kicker1 = strengths1[1].group_by { |rank| rank }.select { |rank, cards| cards.size == 1 }.map(&:first)
	kicker2 = strengths2[1].group_by { |rank| rank }.select { |rank, cards| cards.size == 1 }.map(&:first)
	if four_rank1[0] > four_rank2[0]
	  return "1"
	elsif four_rank2[0] > four_rank1[0]
	  return "2"
	elsif kicker1[0] > kicker2[0]
	  return "1"
	elsif kicker2[0] > kicker1[0]
	  return "2"
	else
	  return "tie"
	end
      when "full house", "three of a kind"
        three_rank1 = strengths1[1].group_by { |rank| rank }.select { |rank, cards| cards.size == 3}.map(&:first)
	three_rank2 = strengths2[1].group_by { |rank| rank }.select { |rank, cards| cards.size == 3}.map(&:first)
	kickers1 = strengths1[1].group_by { |rank| rank }.select { |rank, cards| cards.size <= 2 }.map(&:first)
        kickers2 = strengths2[1].group_by { |rank| rank }.select { |rank, cards| cards.size <= 2 }.map(&:first)
	if three_rank1[0] > three_rank2[0]
	  return "1"
	elsif three_rank2[0] > three_rank1[0]
	  return "2"
	elsif kickers1.size == 1
	  if kickers1[0] > kickers2[0]
	    return "1"
	  elsif kickers2[0] > kickers1[0]
	    return "2"
	  else
	    return "tie"
	  end
	elsif kickers1.size == 2
	  if kickers1[0] > kickers2[0]
	    return "1"
	  elsif kickers2[0] > kickers1[0]
	    return "2"
	  elsif kickers1[1] > kickers2[1]
	    return "1"
	  elsif kickers2[1] > kickers1[1]
	    return "2"
	  else
	    return "tie"
	  end
	end
      when "two pair", "one pair"
        pair_rank1 = strengths1[1].group_by { |rank| rank }.select { |rank, cards| cards.size == 2 }.map(&:first)
        pair_rank2 = strengths2[1].group_by { |rank| rank }.select { |rank, cards| cards.size == 2 }.map(&:first)
        kickers1 = strengths1[1].group_by { |rank| rank }.select { |rank, cards| cards.size == 1 }.map(&:first)
        kickers2 = strengths2[1].group_by { |rank| rank }.select { |rank, cards| cards.size == 1 }.map(&:first)
	if pair_rank1.size == 2
	  if pair_rank1[0] > pair_rank2[0]
	    return "1"
	  elsif pair_rank2[0] > pair_rank1[0]
	    return "2"
	  elsif pair_rank1[1] > pair_rank2[1]
	    return "1"
	  elsif pair_rank2[1] > pair_rank1[1]
	    return "2"
	  elsif kickers1[0] > kickers2[0]
	    return "1"
	  elsif kickers2[0] > kickers1[0]
	    return "2"
	  else
	    return "tie"
	  end
	elsif pair_rank1.size == 1
	  if pair_rank1[0] > pair_rank2[0]
	    return "1"
	  elsif pair_rank2[0] > pair_rank1[0]
	    return "2"
	  else
	    kickers1.zip(kickers2).each do |kicker|
	      if kicker[0] > kicker[1]
	        return "1"
	      elsif kicker[1] > kicker[0]
	        return "2"
	      elsif kicker[1] == kicker[0] && kicker[0] == kickers1[2]
	        return "tie"
	      end
	    end
	  end
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
