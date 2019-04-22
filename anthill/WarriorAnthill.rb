require_relative 'Anthill'
class WarriorAnthill < Anthill 
	attr_reader :forager_chance, :warrior_chance, :builder_chance
	def initialize(name,x,y)
		super(name,x,y)
		@forager_chance = 2 # => 20% chance of building a forager
		@warrior_chance = 8 # => 60% chance of building a warrior
		@builder_chance = 10# => 20% chance of building a builder
	end
end
