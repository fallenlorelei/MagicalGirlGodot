extends Node2D

onready var map = $TileMap
onready var camera = $Camera2D
onready var player = $YSort/Player
onready var cameraLimitShape = $CameraLimit

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {
	Vector2(0,-1): N,
	Vector2(1,0): E,
	Vector2(0,1): S,
	Vector2(-1,0): W}
	
var tile_size = 640
# fraction of walls to remove. How much removing do we want?
var erase_fraction = 0.85

export var map_seed = 0
export var width = 7
export var height = 5
export var first_tile = Vector2(3,0)

func _ready():
	randomize()
	
	if !map_seed:
		map_seed = randi()
	seed(map_seed)
	print("Maze Seed: ", map_seed)
	player.map_pos = first_tile
	player.position = map.map_to_world(player.map_pos) + Vector2(320,320)
	
	cameraLimitShape.rect_position = Vector2(0,0)
	cameraLimitShape.rect_size = Vector2(width * tile_size, height * tile_size)
	camera.limit_left   = 0
	camera.limit_right  = cameraLimitShape.rect_size.x
	camera.limit_top    = 0
	camera.limit_bottom = cameraLimitShape.rect_size.y
	
	tile_size = map.cell_size
	make_maze()
	erase_walls()
	
#Give it a cell, and then a list of cells that are unvisited (by the mazerunner)
func check_neighbors(cell, unvisited):
	#returns array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func make_maze():
	var unvisited = [] #array of unvisited tiles
	var stack = [] #godot doesn't have actual "stacks" but we can use arrays to pop back
	
	#fill the map with solid tiles
	map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x,y)) #adding all the cells to unvisited
			map.set_cellv(Vector2(x, y), N|E|S|W) # setting cell to N=1,E=2,S=4,W=8 = 15 (solid color in tilemap). These are in binary. Big shrug.
	var current = first_tile # starting cell, can be anywhere
	unvisited.erase(current) # removing starting cell from unvisited list
	
	#begin algorithm!
	
	while unvisited: #as long as unvisited array is not empty
		var neighbors = check_neighbors(current, unvisited) #how many unvisited neighbors do we have?
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()] #pick a random neighbor
			stack.append(current) #put current cell in the stack. I think it starts immediately at "all 4 walls"
			
			#remove walls from *both* cells
			var dir = next - current #returns direction we just moved in (0,1), (-1,0) etc.
			var current_walls = map.get_cellv(current) - cell_walls[dir] #subtracting the direction's wall from both cells. Example: current cell is 15. We moved "up" which is 0,-1 which is North which is 1. Removed the north wall, so we remove 1. 15 becomes 14. This is a cell with north wall open.
			var next_walls = map.get_cellv(next) - cell_walls[-dir] #Same thing but opposite, direction is opposite. Removing South wall.
			map.set_cellv(current, current_walls) #Setting the cells
			map.set_cellv(next, next_walls) #This only works because the tile IDs match the 0-15 binary numbers we are getting.
			current = next #Setting new current cell
			unvisited.erase(current) #Taking it out of unvisited
		elif stack:
			current = stack.pop_back()

func erase_walls():
	#randomly remove a number of walls on map
	for _i in range(int(width * height * erase_fraction)):
		var x = int(rand_range(1,width-1))
		var y = int(rand_range(1,height-1))
		var cell = Vector2(x, y)
		#pick random neighbor
		var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
		# if there's a wall, remove it
		if map.get_cellv(cell) & cell_walls[neighbor]:
			var walls = map.get_cellv(cell) - cell_walls[neighbor]
			var neighbor_walls = map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
			map.set_cellv(cell, walls)
			map.set_cellv(cell+neighbor, neighbor_walls)
