extends Area2D

export var ACCELERATION = 200
export var MAX_SPEED = 20
export var FRICTION = 150
export var TOLERANCE = 60

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var state = IDLE

onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController

signal start_movement

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
#	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
#	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()			
			if wanderController.get_time_left() == 0:
				update_wander()
			
			
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()			
			accelerate_towards_point(wanderController.target_position, delta)
					
			if global_position.distance_to(wanderController.target_position) <= TOLERANCE * delta:
				update_wander()

			
			
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			
			else:
				state = IDLE
			
				
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400


	


func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3))


func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	emit_signal("start_movement")
	

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
