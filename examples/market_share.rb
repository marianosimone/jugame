in_the_game "The Market Share", 2.players do
  choose_to "Act as Hawk"
  choose_to "Act as Pigeon"
  when_their_choices_are "Act as Hawk", "Act as Hawk", they_gain = 1,1
  when_their_choices_are "Act as Pigeon", "Act as Pigeon", they_gain = 2,2
  when_their_choices_are "Act as Pigeon", "Act as Hawk", they_gain = 0,4
  when_their_choices_are "Act as Hawk", "Act as Pigeon", they_pay = 4, 0
end

the_strategy "AlwaysHawk" do
  "Act as Hawk"
end

the_strategy "AlwaysPigeon" do
  "Act as Pigeon"
end

the_strategy "TitForTat" do |context|
  while_the_other_in context, "Act as Pigeon", "Act as Pigeon", :and_then => mimic(context)
end

the_strategy "Vendetta" do |context|
  while_the_other_in context, "Act as Pigeon", "Act as Pigeon", :and_then => "Act as Hawk"
end

the_strategy "Copycat" do |context|
  mimic context
end
