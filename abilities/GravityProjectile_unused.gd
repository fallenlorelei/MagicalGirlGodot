extends Node

const GRAVITY = 500
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	move_and_collide(velocity * delta)
	
func calculate_arc_velocity(source_position, target_position, arc_height, gravity):
	var displacement = target_position - source_position
	
	if displacement.y > arc_height:
		var time_up = sqrt(-2 * arc_height / float(gravity))
		var time_down = sqrt(2 * (displacement.y - arc_height) / float(gravity))
		
		velocity.y = -sqrt(-2 * gravity * arc_height)
		velocity.x = displacement.x / float(time_up + time_down)
	
	return velocity


func projectile(target_position):
	#calculate arc_height based on distance
	var distance = abs(target_position.x - global_position.x)
	var max_height = distance * 0.5
	
	var arc_height = target_position.y - global_position.y - max_height
	arc_height = min(arc_height, -max_height)
	velocity = calculate_arc_velocity(global_position, target_position, arc_height, GRAVITY)
