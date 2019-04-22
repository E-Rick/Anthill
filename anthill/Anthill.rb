#Anthills contains Room objects that spawn an Ant object, consuming 1 piece of food
#Room creation kills the builder ant who created it
#Ant creation is dependant on room type
#Object Runtime Modification is used to add forager, builder, or warrior functionality to the ants
class Anthill
    
	attr_reader :coordinates, :name
	attr_accessor :food, :colony_kills, :ant_kills, :builders, :foragers, :warriors
	def initialize(name, x, y)
		@foragers = [] # => They will contain ant objects
		@warriors = [] # => They will contain ant objects
		@builders = [] # => They will contain ant objects
		@food = 7
		@name = name
		@ant_kills = 0
		@colony_kills = 0
		@coordinates = [x,y]
	end

	def buildAnt(field)
		#Returns true if food is available to make a room and makes the ant
		if @food >= 2
			#Each anthill will have at least one builder always ready 
			if self.class.name == 'ForagerAntHill'
				if (@foragers.length < @warriors.length) || (@foragers.length == @warriors.length) 
					#add forager ant
					ant = ForagerRoom.new(self).createAntFactory
					@foragers << ant
				else
					#add warrior ant
					ant = WarriorRoom.new(self).createAntFactory
					@warriors << ant
				end
			else
				if (@warriors.length < @foragers.length) || (@foragers.length == @warriors.length) 
					#add warrior ant
					ant = WarriorRoom.new(self).createAntFactory
					@warriors << ant
				else
					#add forager ant
					ant = ForagerRoom.new(self).createAntFactory
					@foragers << ant
				end
			end
			
			@builders.pop

			#Get anthill coordinates
			x = @coordinates[0]
			y = @coordinates[1]

			#Add non builder ants to field cell
			field[x][y].ants << ant if ant.class.name != 'BuilderAnt'
			@food -= 1
			

			#Create Another builder to always have a builder ready for next ant
			BuilderRoom.new(self).createAntFactory
			@builders << ant
			@food -= 1

			@builders.pop()

			true
		elsif @foragers.length == 0 && @food > 0

			ant = ForagerRoom.new(self).createAntFactory
			@foragers << ant

			@builders.pop
		
			#Get anthill coordinates
			x = @coordinates[0]
			y = @coordinates[1]

			#Add non builder ants to field cell
			field[x][y].ants << ant if ant.class.name != 'BuilderAnt'
			@food -= 1
			true
		else
			false
		end
	end
end
