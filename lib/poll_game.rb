# Module that automatically creates a payoff matrix based on the player's preferences
# It assumes simple majority and uses a tie_breaker in case of tie
module JugaMe::PollGame
  attr_reader :tie_breaker, :players_preferences

  # Sets the preferences of the [player_number] player for each of the moves (descending order, being the first one the favourite)
  # [player_number] should be between 1 and the number_of_players
  # Preferences should be a hash in the form {move => pointsIfWinner}
  # In case you don't set a preference for a certain move, 0 is assumed
  def preference(player_number, preferences)
    validate player_number, preferences
    @players_preferences ||= {}
    @players_preferences[player_number] = preferences
  end

  # Builds the payoff matrix, based on preferences
  def calculate_matrix
    raise JugaMe::NoTieBreakerInPollException if tie_breaker.nil?
    raise JugaMe::IncompletePollPreferencesException if players_preferences.size != number_of_players
    combinations = moves
    (number_of_players-1).times do
      combinations = combinations.cart_product(moves)
    end
    combinations.each do |combination|
      modes = combination.modes
      winner = (modes.size == 1) ? modes.first : combination[tie_breaker-1]
      payoffs = []
      number_of_players.times do |i|
        payoffs << (players_preferences[i+1][winner] || 0)
      end
      set_payoff(combination,payoffs)
    end
  end

  def tie_breaker=(breaker)
    validate_player breaker
    @tie_breaker = breaker
  end

private
  def validate(player_number,preferences)
    validate_player player_number
    preferences.keys.each do |p|
      raise JugaMe::UnknownMoveException.new(self,p) unless moves.include? p
    end
  end

  def validate_player(player)
    raise JugaMe::UnknownPlayerException.new(self, player) if (player < 1 or player > number_of_players)
  end
end
