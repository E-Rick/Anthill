#Contains information about each cell in the meadow field
class Cell 
	attr_accessor :food, :ants, :hill

	def initialize(hill=nil) 
		@hill = hill
		@food = 0
		@ants = []
	end
end
