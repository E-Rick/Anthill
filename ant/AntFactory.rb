require_relative 'Ant'
require_relative 'WarriorAnt'
require_relative 'ForagerAnt'
require_relative 'BuilderAnt'
class AntFactory
	def createAnt(ant_type,anthill)
		ant = ant_type.new(anthill)
	end
end
