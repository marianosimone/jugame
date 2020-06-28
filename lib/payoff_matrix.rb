module JugaMe
# Class that represents a the Payoff Matrix of a game.
# Example:
# In Rock-paper-scissors, the Payoff Matrix is:
#          |   Rock   |   Paper   | Scissors |
# Rock     |   (0,0)  |   (0,1)   |   (1,0)  |
# Paper    |   (1,0)  |   (0,0)   |   (0,1)  |
# Scissors |   (0,1)  |   (1,0)   |   (0,0)  |
#
# Validation is left to the user, as different rules may apply
class PayoffMatrix
  def initialize
    @matrix = {}
  end

  # Set the array of payoffs for a certain combination of moves (decisions taken by players)
  def set_pay_off(moves, payoffs)
    @matrix[moves.collect {|m| m.to_sym}] = payoffs
  end

  # Given an array of moves (decisions taken by players), return their payoffs
  def get_pay_off(moves)
    @matrix[moves.collect {|m| m.to_sym}]
  end

  # Number of registered payoffs
  def size
    @matrix.size
  end
end

end
