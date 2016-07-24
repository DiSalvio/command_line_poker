class TieBreaker
  def self.winner(strengths1, strengths2)
    case strengths1[0]
      when "straight flush", "straight"
        if strengths1[1][0] > strengths2[1][0]
	  return "1"
	elsif strengths2[1][0] > strengths1[1][0]
	  return "2"
	else
	  return "Tie!"
	end
      when "flush", "high card"
        strengths1[1].zip(strengths2[1]).each do |card|
	  if card[0] > card[1]
	    return "1"
	  elsif card[1] > card[0]
	    return "2"
	  elsif card[1] == card[0] && card[0] == strengths[1][4]
	    "Tie!"
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
         return "Tie!"
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
	   return "Tie!"
	 end
       elsif kickers1.size == 2
         if kickers1[0] > kickers2[0]
	   return "1"
	 elsif kickers2[0] > kickers[1]
	   return "2"
	 elsif kickers1[1] > kickers2[1]
	   return "1"
	 elsif kickers2[1] > kickers2[1]
	   return "2"
	 else
	   return "Tie!"
	 end
       elsif kickers1[0] > kickers2[0]
         return "1"
       elsif kickers2[0] > kickers1[0]
         return "2"
       else
         return "Tie!"
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
	       return "Tie!"
	     end
	   end
	 end
       end
     end
  end
end
