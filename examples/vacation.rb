in_the_game "Vacation", 3.players do
  vote_to "Go To Gral. Belgrano"
  vote_to "Go To Pinamar"
  vote_to "Go To Viedma"
  player 1, :prefers_to => ["Go To Gral. Belgrano","Go To Viedma"]
  player 2, :prefers_to => ["Go To Viedma","Go To Pinamar"]
  player 3, :prefers_to => ["Go To Pinamar","Go To Gral. Belgrano"]
  tie_breaker_is 2
end

the_strategy "AlwaysBelgrano" do
  "Go To Gral. Belgrano"
end

the_strategy "AlwaysViedma" do
  "Go To Viedma"
end

the_strategy "AlwaysPinamar" do
  "Go To Pinamar"
end
