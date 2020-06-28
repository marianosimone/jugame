# Script to run a tournament using the game definition and strategies in the script passed as argument
require '../ruby/addons'
require 'jugame'
require 'jugame_dsl'
require 'rubygems'
require 'highline'
require "highline/import" 

def play(game,number_of_plays,strategies_groups)
strategies_groups.each_with_index do |strategies,index|
  players = strategies.map {|strategy| strategy.new(game.moves)}
  execution = JugaMe::GameExecution.new(game, players)
  result = execution.play(number_of_plays)
  puts strategies.join(" vs ")
  puts result.inspect
  winner = result.winner_result
  puts "Ganador: #{winner.strategy.class} con #{winner.total_payoff} punto#{winner.total_payoff.abs > 1 ? 's' : ''}"
  puts "---------------------------------------"
  STDIN.getc
end
end

def game_menu(game, number_of_plays, strategies_groups)
  choose do |menu|
    menu.prompt = "¿Qué estrategias compiten?  "
    strategies_groups.each do |group|
      menu.choice(group.inspect) { play(game,number_of_plays,[group]) }
    end
    menu.choice("Todas") {play(game,number_of_plays,strategies_groups)}
    menu.choice("Ninguna") { exit 0 }
  end
end

if (ARGV.size != 1 and ARGV.size != 2)
  puts "Uso:"
  puts "#{__FILE__} definicion_de_juego [cantidad_de_rondas]"
  exit 1
end

begin
file = ARGV[0]
require file

number_of_plays = ARGV[1].to_i > 0 ? ARGV[1].to_i : 1
competitors = JugaMe::Strategy.subclasses

game = JugaMe::Game.games.values.first
strategies_groups = competitors.in_groups_of game.number_of_players

while true
  game_menu(game, number_of_plays, strategies_groups)
end

rescue JugaMe::UnknownMoveException => e
  puts "Hubo un error de configuración (posiblemente en las estrategias), revise el archivo #{file}:",e
rescue JugaMe::InvalidPayoffMatrixException
  puts "Hubo un error en la definición de la matriz del juego, revise el archivo #{file}:"
end
