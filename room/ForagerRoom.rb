#ForagerRoom initiates the creation of the ForagerAnt, Takes the anthill as a parameter that will be stored in the Ant object
require_relative 'Room'
class ForagerRoom < Room
	def initialize(anthill)
		@type = ForagerAnt
		@hill = anthill
	end
	def createAntFactory
		ant = AntFactory.new.createAnt(@type,@hill)
	end
end
