extends Line2D

var length
var point = Vector2()
onready var particles = $Particles2D

func _process(_delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	
	particles.global_position = get_parent().global_position
	point = get_parent().global_position
	
	add_point(point)
	
	while get_point_count()>length:
		remove_point(0)
