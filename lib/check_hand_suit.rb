class CheckHandSuit
  def same_suit(suits)
    "flush" if (suits.uniq.length == 1)
  end
end
