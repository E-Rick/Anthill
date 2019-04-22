require_relative 'Anthill'
class ForagerAnthill < Anthill
	attr_reader :forager_chance, :warrior_chance, :builder_chance
	def initialize(name,x,y)
		super(name,x,y)
		@forager_chance = 6 # => 60% chance of building a forager
		@warrior_chance = 8 # => 20% chance of building a warrior
		@builder_chance = 10# => 20% chance of building a builder
	end
end
