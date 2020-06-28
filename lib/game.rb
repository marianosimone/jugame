require 'jugame_exceptions'
require 'payoff_matrix'
require 'game_execution'

module JugaMe
class Game
  public
  attr_reader :name, :payoff_matrix, :number_of_players, :moves
  def initialize(name, number_of_players)
    @name = name
    @moves = []
    @number_of_players = number_of_players
    @payoff_matrix = PayoffMatrix.new
  end

  def add_moves(moves)
    self.moves += [*moves]
  end

  def set_payoff(moves, payoffs)
    validate_moves(moves)
    validate_payoffs(payoffs)
    @payoff_matrix.set_pay_off(moves, payoffs)
    @valid_matrix = false
  end

  def get_payoff(moves)
    validate_moves(moves)
    validate_matrix unless valid_matrix?
    @payoff_matrix.get_pay_off(moves)
  end

  def validate_matrix
    raise InvalidPayoffMatrixException.new if @payoff_matrix.size != moves.size**number_of_players
    @valid_matrix = true
  end

private
  attr_writer :moves
  def validate_moves(moves)
    moves = [*moves]
    moves.each{|move| raise UnknownMoveException.new(self,move) unless @moves.include?(move) }
    raise InvalidPayoffException.new("Moves are: #{moves.inspect}") if moves.size != number_of_players
  end

  def validate_payoffs(payoffs)
    payoffs = [*payoffs]
    raise InvalidPayoffException.new("Payoffs are: #{payoffs.inspect}") if payoffs.size != number_of_players    
  end

  def valid_matrix?
    @valid_matrix ||= false
  end
end
end
