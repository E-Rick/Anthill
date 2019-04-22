require_relative 'Ant'
class WarriorAnt < Ant
	attr_accessor :movement, :xp, :anthill
	def initialize(anthill)
		#Keep track of the ant's movement
		initial_position = anthill.coordinates
		@anthill = anthill
		@movement = [] 
		@movement << initial_position
		@xp = 1
	end
end
