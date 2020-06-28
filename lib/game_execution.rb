require 'game'

module JugaMe

# A composition of moves (decisions taken) and payoffs (gotten because of the decisions)
class IndividualGameExecutionResult
  attr_reader :moves, :payoffs, :strategy
  def initialize(strategy)
    @strategy = strategy
    @moves = []
    @payoffs = []
  end

  # The sum of all payoffs
  def total_payoff
    payoffs.inject {|sum, n| sum + n } 
  end

  def inspect
    "Moves: #{moves.inspect}, Payoffs: #{pay_offs.inspect}"
  end

end

# The result of n execution(s)
class GameExecutionResult
  attr_reader :individual_results
  def initialize
    @individual_results = Hash.new{|hash, key| hash[key] = IndividualGameExecutionResult.new(key)}
  end

  # A Hash (strategy => IndividualGameExecutionResult), sorted by descending payoff
  def sorted_results
    individual_results.sort {|x,y| y[1].total_payoff <=> x[1].total_payoff }
  end

  # The IndividualGameExecutionResult with the biggest payoff
  def winner_result
    sorted_results.first[1]
  end

  def inspect
    str = ""
    sorted_results.each do |r|
      str += "#{r[0].class}: #{r[1].total_payoff}\n"
    end
    str
  end
end

class GameExecution
  attr_reader :strategies, :game

  def initialize(game, strategies)
    raise InvalidNumberOfStrategiesException.new if (strategies.size != game.number_of_players)
    @strategies = strategies
    @strategies.each do |str1|
      @strategies.each{|str2| str1.add_observer(str2) unless str1 == str2}
    end
    @game = game
  end

  #Asks each Player to take a decision number_of_times times, and returns the results
  def play(number_of_times = 1)
    result = GameExecutionResult.new
    number_of_times.times {|i|
      moves = []
      strategies.each do |strategy|
        move = strategy.play
        moves << move
        result.individual_results[strategy].moves << move 
      end
      pay_offs = game.get_payoff(moves)
      strategies.each_with_index { |strategy,i|
        result.individual_results[strategy].payoffs << pay_offs[i]
      }
    }
    return result
  end
end
end
