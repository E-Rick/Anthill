#WarriorRoom initiates the creation of the WarriorAnt, Takes the anthill as a parameter that will be stored in the Ant object
require_relative 'Room'
class WarriorRoom < Room
	def initialize(anthill)
		@type = WarriorAnt
		@hill = anthill
	end
	def createAntFactory
		ant = AntFactory.new.createAnt(@type,@hill)
	end
end
