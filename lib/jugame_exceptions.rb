module JugaMe

class InvalidPayoffMatrixException < Exception; end

class InvalidPayoffException < Exception
  def initialize(message)
    @message = message
  end

  def to_s
   "#{@message}"
  end
end

class InvalidNumberOfStrategiesException < Exception; end

class UnknownMoveException < Exception
  def initialize(game, move)
    @game = game
    @move = move
  end

  def to_s
   "Unknown Move: '#{@move}' in Game '#{@game.name}'"
  end
end

class NoTieBreakerInPollException < Exception; end
class IncompletePollPreferencesException < Exception; end
class UnknownPlayerException < Exception
  def initialize(game, player)
    @game = game
    @player = player
  end

  def to_s
   "Unknown Player: '#{@player}' in Game '#{@game.name}' (should be between 1 and #{@game.number_of_players})"
  end
end

end
