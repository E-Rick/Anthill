# Anthill Simulation | Survival of the Fittest

A naive ant colony simulation where only the best survives 

### Project Structure
    .                              
    ├── ant            # Ant factory and ant types
    ├── anthill        # Anthill and anthill types
    ├── meadow         # Meadow grid builder
    ├── room           # Anthill rooms
    ├── driver         # main
    └── README.md 

### Description of Design
Forager Ant:
* When the Forager ant dies, it drops the food it was carrying
on the cell it dies in.
* When the Forager Ant delivers the food it was carrying to the
Anthill it is from, it gains one additional experience. This
experience is used to give him/her the ability to move 2 cells
at a time.
* The Forager dies as soon as it gets inside a cell where a
Warrior ant of the opposing Anthills is situated.

Warrior Ant:
* It will try to destroy an anthill when it stumbles in a cell 
where the anthill is in. If it doesn't destroy it, it can also
be challenged by a warrior of an opposing anthill in the same
cell. 
	- The ant has a 1/5 chance of destroying the hill
	- If it doesn't and there also isn't any warrior in the
	same cell then it moves to another cell in the next turn
* When a warrior kills another it will gain experience. This 
experience can be used to have greater chances of winning a battle 
with another warrior

Builder Ant:
* It just creates the rooms which in turn create the ants

Strategy for Building the AntHills: (Initially)
* If the AntHill is a ForagerAntHill, creates the following
	- 2 Builders
	- 2 Foragers
	- 1 Warrior
* If the AntHill is a WarriorAntHill, creates the following
	- 2 Builders
	- 2 Warriors
	- 1 FOrager

Strategy for Building the AntHills: (All along)
* If the food is abundant (>= 2)
	- If ForgerAntHill then
		+ If there are more warriors than foragers or 
		an equal amount of foragers and warriors, create
		a forager, else create a warrior
	- If WarriorAntHill then
		+ If there are more foragers than warriors or 
		an equal amount of warriors and foragers, create
		a warrior, else create a forager
	- And always build a warrior along!
* If the food is less abundant
	- Build a Forager to bring some more food.

Startegy:
* Many startegies have been tested and none resulted in a 
particularly satisfying result, I have thus chosen to go 
for the last option tried.
	


