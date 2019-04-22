require_relative 'Ant'
class ForagerAnt < Ant
	attr_accessor :movement, :found_food, :xp, :anthill
	def initialize(anthill)
		#Keep track of the ant's movement
		initial_position = anthill.coordinates
		@anthill = anthill
		@movement = [] 
		@movement << initial_position
		@found_food = false
		@xp = 1
	end
end
