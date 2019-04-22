require_relative '../ant/AntFactory'
class Room
	def initialize(anthill)
		@hill = anthill
	end
	def createAntFactory
		raise NoMethodError.new
	end
end
