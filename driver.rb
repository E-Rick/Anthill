require_relative './meadow/MeadowBuilder'
def main 
	builder = MeadowBuilder.new
	meadow = builder.createField(25,25).addHill('Sloth').addHill('Gluttony').addHill('Envy').addHill('Pride').addHill('Hope').addHill('Lust').addHill('Wrath').addHill('Poison').addHill('Destiny').addHill('Greed').build
	
	cnt = 1
	while meadow.anthills.length > 1
		meadow.placeFood
		meadow.moveAnts
		
		if cnt%5 == 0
		 	meadow.to_s
		end
		cnt += 1
	end
	puts "------------------- WINNING ANTHILL --------------------------\n"
	meadow.to_s
end

main
