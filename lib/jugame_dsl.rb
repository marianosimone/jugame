require 'jugame'
require 'jugame_dsl_exceptions'
require 'jugame_dsl_game'
require 'jugame_dsl_strategy'

# Some syntax sugar to make the number itself have some meaning
class Fixnum
  def players
    self
  end
end

# Opening the Object class and adding some methods to create new games and strategies
class Object
  def in_the_game(name, number_of_players, &block)
    JugaMe::Game.define_game(name, number_of_players, &block)
  end

  def choose_to(move)
    JugaMe::Game.add_move_to_game(move)
  end

  def vote_to(move)
    JugaMe::Game.add_vote_to_game(move)
  end

  def when_their_choices_are(*args)
    JugaMe::PayoffBuilder.build(args)
  end

  def player(player_number, preferences)
    raise "Player #{player_number} should :prefer_to do something" if preferences[:prefers_to].nil?
    JugaMe::Game.add_player_preferences(player_number, preferences[:prefers_to])
  end

  def tie_breaker_is tie_breaker
    JugaMe::Game.current_game.tie_breaker = tie_breaker
  end
end

module JugaMe
class PayoffBuilder
  def self.build(args)
    moves = args.select{|arg| arg.is_a? String }
    payoffs = args.select{|arg| arg.is_a? Fixnum }
    payoffs*=moves.size if payoffs.size == 1
    Game.current_game.set_payoff(moves,payoffs)
  end
end
end
