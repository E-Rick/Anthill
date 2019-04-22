require_relative 'Meadow'
require_relative 'Cell'
require_relative '../anthill/Anthill'
require_relative '../anthill/WarriorAnthill'
require_relative '../anthill/ForagerAnthill'
require_relative '../room/Room'
class MeadowBuilder

	def initialize
		@anthills = []
		@field = nil
	end

    	#Creates the field dimensions according to parameters
	def createField(rows,columns)
		@rows = rows
		@columns = columns
		@field = Array.new(rows) {Array.new(columns,Cell.new)}
		self
	end

    	#Adds a anthill to the list of anthills
	def addHill(name)
		@anthills << name 
		self
	end

    	#Builds meadow and returns meadow if configured properly
	def build
		@hills = []
		if @anthills.length == 10 && @field
			x = (0...@rows).to_a.shuffle.take(10)
			y = (0...@columns).to_a.shuffle.take(10)
			@anthills.each_with_index do |hill, i|
				hill_type = rand(0..1)
				if hill_type == 0
					@hills << WarriorAnthill.new(hill,x[i],y[i])
				else
					@hills << ForagerAnthill.new(hill,x[i],y[i])
				end
				@field[x[i]][y[i]] = Cell.new(@hills[i])
			end
			@meadow = Meadow.instance.create(@field, @hills, @rows, @columns)
		else 
			puts "Not enough hills or field not created"
		end
		@meadow
	end
end
