module JugaMe
class Game
  def self.define_game(name, number_of_players, &block)
    begin
    games[name] = Game.new(name, number_of_players)
    @@current_game = games[name]
    block.call
    current_game.calculate_matrix if current_game.respond_to? :calculate_matrix
    current_game.validate_matrix
    rescue JugaMe::InvalidPayoffMatrixException
      @@current_game = nil
      games.delete name
      raise
    end
  end

  def self.games
    @@games ||= {}
  end

  def self.add_move_to_game(move)
    current_game.add_moves(move)
  end

  def self.add_vote_to_game(move)
    current_game.extend(JugaMe::PollGame) unless current_game.kind_of? JugaMe::PollGame
    current_game.add_moves(move)
  end

  def self.add_player_preferences(player_number, preferences)
    max_points = current_game.moves.size-1
    new_preferences = {}
    preferences.each_with_index do |move, i|
      new_preferences[move] = max_points - i
    end
    current_game.preference(player_number, new_preferences)
  end

  def self.current_game
    raise NotInGameDefinition unless @@current_game
    @@current_game
  end
end
end
