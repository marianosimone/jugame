in_the_game "The Prissioner's Dilemma", 2.players do
  choose_to "Betray"
  choose_to "Stay Silent"
  when_their_choices_are "Betray", "Betray", they_pay = -5
  when_their_choices_are "Stay Silent", "Stay Silent", they_pay = -1
  when_their_choices_are "Stay Silent", "Betray", they_pay = -10, 0
  when_their_choices_are "Betray", "Stay Silent", they_pay = 0, -10
end

the_strategy "AlwaysStaySilent" do
  "Stay Silent"
end

the_strategy "AlwaysBetray" do
  "Betray"
end

the_strategy "TitForTat" do |context|
  while_the_other_in context, "Stay Silent", "Stay Silent", :and_then => mimic(context)
end

the_strategy "Vendetta" do |context|
  while_the_other_in context, "Stay Silent", "Stay Silent", :and_then => "Betray"
end

the_strategy "Copycat" do |context|
  mimic context
end
