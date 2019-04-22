require_relative '../ant/WarriorAnt'
require_relative '../ant/ForagerAnt'
require_relative '../ant/BuilderAnt'
require_relative '../ant/AntFactory'
require_relative '../room/Room'
require_relative '../room/ForagerRoom'
require_relative '../room/BuilderRoom'
require_relative '../room/WarriorRoom'

require 'singleton'
class Meadow
	attr_accessor :anthills, :field, :rows, :columns, :meadow
    
	include Singleton

	#Creates the meadow field and initializes anthills with 5 ants
	def create(field,anthills,rows,columns)
		@field = field
		@anthills = anthills
		@rows = rows
		@columns = columns
		#Create a set of ants for each of the anthill that been initialized
		@anthills.each do |anthill|
			makeStartingFive(anthill)
		end
		self
	end
    
	#Places food randomly within the field
	def placeFood
		row = rand(0...@rows)
		column = rand(0...@columns)
		@anthills.each do |anthill|
			if anthill.coordinates == [row, column]
				return
			end
		end
		@field[row][column].food += 1  
	end

	#Computes each anthill's turns    
	def moveAnts
		@anthills.each do |hill|
			moveWarrior(hill)  
			moveForager(hill)
			moveBuilder(hill)  
		end
	end

	#Makes the starting five ants for each anthill 
	def makeStartingFive(anthill)
		#Get anthill coordinates
		x = anthill.coordinates[0]
		y = anthill.coordinates[1]

		#Each anthill will have at least one builder always ready
		#Forager Anthill starting ratio: 2 Foragers, 1 Warrior, 2 Builder
		if anthill.class.name == 'ForagerAntHill'
			2.times do
				#add forager ant to anthill array and to field cell
				ant = ForagerRoom.new(anthill).createAntFactory
				anthill.foragers << ant
				@field[x][y].ants << ant
				anthill.food -= 1
			end

			#add two warrior ant
			ant = WarriorRoom.new(anthill).createAntFactory
			anthill.warriors << ant
			@field[x][y].ants << ant
			anthill.food -= 1

		#Warrior Anthill starting ratio: 2 Warriors, 1 Forager, 2 Builder
		else
			3.times do
				#add warrior ant to anthill array and to field cell
				ant = WarriorRoom.new(anthill).createAntFactory
				anthill.warriors << ant
				@field[x][y].ants << ant
				anthill.food -= 1
			end

			#add one forager ant to anthill array and to field cell
			ant = ForagerRoom.new(anthill).createAntFactory
			anthill.foragers << ant
			@field[x][y].ants << ant
			anthill.food -= 1
			
		end
		
		#add two builder ants to anthill array
		2.times do
			ant = BuilderRoom.new(anthill).createAntFactory
			anthill.builders << ant
			anthill.food -= 1

		end
	end

	#Computes each warrior's turn within a anthill
	def moveWarrior(anthill)
		anthill.warriors.each do |ant|
			#Move warrior ant randomly
			moveAnt(ant)

			#Get warrior current position
			current_position = ant.movement.last
			x = current_position[0]
			y = current_position[1]

			#Check if the cell has an ant_hill in it and of another type
			if (@field[x][y].hill != nil && @field[x][y].hill != anthill)
				success_chance = rand(1..10) #chance to destory anthill
				if (success_chance == 1 or success_chance == 2)
					destroyAnthill(@field[x][y].hill)
					anthill.colony_kills += 1
					ant.xp = 2
				end
			end

			#Checks if the cell has a Forager or a Warrior if more than one ant in cell
			if @field[x][y].ants.length > 1
				@field[x][y].ants.each do |cell_ant|
					#Check if cell ant is from another anthill
					if cell_ant.anthill != anthill 
						#Check if warrior
						if cell_ant.class.name == 'WarriorAnt'
							loser = runWarriorBattle(ant,cell_ant)
							@field[x][y].ants.delete(loser)
							loser.anthill.warriors.delete(loser)							
						#cell ant is a forager
						else
							@field[x][y].ants.delete(cell_ant)							
							cell_ant.anthill.foragers.delete(cell_ant)
						end
					end
				end
			end			
		end     
	end

	def runWarriorBattle(ant, other_ant)
		#Generate random value to determine winner
		chance = rand(1..10)
		
		#Calculate the ants chances of winning based on different in xp
		#Returns the loser of the battle and increases winner ant's xp
		if ant.xp == other_ant.xp
			if chance <= 5
				ant.xp = 2
				ant.anthill.ant_kills += 1
				other_ant
			else
				other_ant.xp = 2
				other_ant.anthill.ant_kills += 1
				ant
			end
		#If challenging ant has higher xp
		elsif ant.xp > other_ant.xp
			if chance <= 7
				ant.xp = 2
				ant.anthill.ant_kills += 1
				other_ant
			else
				other_ant.xp = 2
				other_ant.anthill.ant_kills += 1
				ant
			end
		#Challened ant has higher xp
		else
			if chance <= 3
				ant.xp = 2
				ant.anthill.ant_kills += 1
				other_ant
			else
				other_ant.xp = 2
				other_ant.anthill.ant_kills += 1
				ant
			end
		end
	end

	#Calculates each forager's moves for anthill (param)
	def moveForager(anthill)
		anthill.foragers.each do |ant|
			i = 0
			begin 
				#Start moving forager reverse back to anthill
				#Calculate ant's moves to return it back to anthill	
				if ant.found_food 
					#Get ant's current position and delete it from current cell
					current_position = ant.movement.first
					x = current_position[0]
					y = current_position[1]
					@field[x][y].ants.delete(ant)
	
					#Remove current position from movement array
					ant.movement = ant.movement.drop(1)
		
					#Move forager to next cell
					next_position = ant.movement.first
					x = next_position[0]
					y = next_position[1]
					@field[x][y].ants << ant

					#Forager is at anthill, deliver the food
					if @field[x][y].hill == ant.anthill
						ant.found_food = false
						anthill.food += 1
						puts "Forager Ant returned food to #{anthill.name}"
					end

				else
					#Move forager randomly
					moveAnt(ant)

					#Get current Position
					current_position = ant.movement.last
					x = current_position[0]
					y = current_position[1]

					#Check if food is in current position
					if @field[x][y].food > 0
						#Update ant xp, reverse movement array, and set flag
						ant.found_food = true
						puts "#{anthill.name} forager ant found food."
						@field[x][y].food -= 1
						ant.xp = 2
						ant.movement = ant.movement.reverse
						break
					end
				end
				i += 1
			end until i == ant.xp

			#Check if forager current position has warrior ants
			@field[x][y].ants.each do |cell_ant|
				#Check if warrior ant present and warrior ant is from another hill
				if cell_ant.class.name == 'WarriorAnt' && cell_ant.anthill != anthill
					#Kill forager ant and drop food
					@field[x][y].ants.delete(ant)
					anthill.foragers.delete(ant)
					@field[x][y].food += 1 if ant.found_food = true
					cell_ant.anthill.ant_kills += 1
				end
			end
		end 
	end

	#Calculates ant's avaiable moves and moves ant from old position to new position
	def moveAnt(ant)
		#Removes ant from old cell position 
		last_position = ant.movement.last
		x = last_position[0]
		y = last_position[1]
		@field[x][y].ants.delete(ant)

		#Calculate ant available movements
		# 0 -> Left; 1 -> Up; 2 -> Right; 3 -> Down
		available_moves = checkMovement(last_position)
		
		#Choose movement randomly from available moves
		move = available_moves.sample

		#Calculate ant new position based on move
		if move == 0 #Left
			current_position = [last_position[0],last_position[1]-1]
		elsif move == 1 #Up
			current_position = [last_position[0]-1,last_position[1]]
		elsif move == 2 #Right
			current_position = [last_position[0],last_position[1]+1]
		else #Down
			current_position = [last_position[0]+1,last_position[1]]
		end

		#Changes ant position to new cell and add ant to new cell
		ant.movement << current_position
		x = current_position[0]
		y = current_position[1]
		@field[x][y].ants << ant
	end

	#Check ant possible moves based on last move position in field 
	#Returns the array of available moves
	def checkMovement(last_move)
		array = [0,1,2,3]
		if last_move[0] == 0
		    #TOP IS NOT POSSIBLE --> use array.sample gives you a random number from an array of numbers!
		    array.delete(1)
		end
		if last_move[0] == @rows - 1 
		    #BOTTOM IS NOT POSSIBLE
		    array.delete(3)
		end
		if last_move[1] == 0
		    #LEFT IS NOT POSSIBLE
		    array.delete(0)
		end
		if last_move[1] == @columns - 1
		    #RIGHT IS NOT POSSIBLE
		    array.delete(2)
		end
		array
	end


	#Calculates all of an anthill builders' turns
	def moveBuilder(anthill)
		anthill.builders.each do |builder|		
			anthill.buildAnt(@field)
			#if status
			#	anthill.builders.delete(builder)
			#end
		end
	end

	#Removes anthill and all its ants from the meadow field
	def destroyAnthill(anthill)
		@field.each do |rows|
			rows.each do |cell|
				anthill.warriors.each do |warrior|
					if cell.ants.include? warrior
						cell.ants.delete(warrior)	
					end
				end
				anthill.foragers.each do |forager|
					if cell.ants.include? forager
						cell.ants.delete(forager)
					end
				end
			end
		end
		position = anthill.coordinates
		x = position[0]
		y = position[1]
		@field[x][y].hill = nil
		@anthills.delete(anthill)
	end

	#To string to print out each anthill statistics
	def to_s
		@anthills.each do |hill|
			puts "Anthill Name: #{hill.name}\nForager Ants: #{hill.foragers.length}\nWarrior Ants: #{hill.warriors.length}\nBuilder Ants: #{hill.builders.length}\nAnt Kills: #{hill.ant_kills}\nColony Kills: #{hill.colony_kills}\n============="			
		end
		nil
   	end
end
