class CheckHandRank
  attr_accessor :hand_ranks_sorted_by_num

  def initialize(hand_ranks)
    @@RANK_NUM = %w(2 3 4 5 6 7 8 9 T J Q K A)
    @hand_ranks_sorted_by_num = hand_ranks.collect { |card| @@RANK_NUM.index(card) }.sort.reverse 
  end

  def consecutive_rank(num_sorted_ranks)
    "straight" if num_sorted_ranks.each_cons(2).all? { |a, b| b == a - 1 }
  end

  def same_rank
    @hand_ranks_sorted_by_num.select { |rank| @hand_ranks_sorted_by_num.count(rank) > 1 }
  end

  def check_rank_hand_strength
    pairs_or_kinds = same_rank
      case [pairs_or_kinds.length, pairs_or_kinds.uniq.length]
        when [5, 2]
          "full house"
        when [4, 1]
          "four of a kind"
        when [4, 2]
          "two pair"
        when [3, 1]
          "three of a kind"
        when [2, 1]
          "one pair"
	when [0, 0]
	  "high card"
       end
  end
end
