in_the_game "Hunters", 2.players do
  choose_to "Hunt Rabbits"
  choose_to "Hunt Deers"
  when_their_choices_are "Hunt Rabbits", "Hunt Rabbits", they_gain = 1
  when_their_choices_are "Hunt Deers", "Hunt Deers", they_gain = 5
  when_their_choices_are "Hunt Rabbits", "Hunt Deers", they_gain = 2, 0
  when_their_choices_are "Hunt Deers", "Hunt Rabbits", they_gain = 0, 2
end

the_strategy "AlwaysRabbits" do
 "Hunt Rabbits"
end

the_strategy "AlwaysDeers" do
 "Hunt Deers"
end

the_strategy "TitForTat" do |context|
  while_the_other_in context, "Hunt Deers", "Hunt Deers", :and_then => mimic(context)
end

the_strategy "Vendetta" do |context|
  while_the_other_in context, "Hunt Deers", "Hunt Deers", :and_then => "Hunt Rabbits"
end

the_strategy "Copycat" do |context|
  mimic context
end
