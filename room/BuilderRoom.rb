#BuilderRoom initiates the creation of the BuilderAnt, Takes the anthill as a parameter that will be stored in the Ant object
require_relative 'Room'
class BuilderRoom < Room
	def initialize(anthill)
		@type = BuilderAnt
		@hill = anthill
	end
	def createAntFactory
		ant = AntFactory.new.createAnt(@type,@hill)
	end
end
