extends "res://entities/EntityBase.gd"

onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderTimer = $WanderTimer
onready var randomCrystal = $RandomCrystal
onready var wanderStartPos = position
onready var wanderTargetPos = position
export(int) var wander_range = 32

func _ready():
	state = pick_random_state([IDLE, WANDER])
	update_wander_target_position()

func _physics_process(delta):	
	match state:
		IDLE:
			idle(delta)
		WANDER:
			wander(delta)
		CHASE:
			chase(delta)
			
	seek_player()
	
# Soft collision is enemies hitting each other and not overlapping
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400

func idle(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)					
	check_wander_timer()

func wander(delta):
	check_wander_timer()
	
	accelerate_towards_point(wanderTargetPos, delta)
	print(wanderTargetPos)
# This keeps the slime from overshooting its target position and running back and forth
# "Tolerance" is a pretty random number that I think should be similar to half the sprite's width
	if global_position.distance_to(wanderTargetPos) <= TOLERANCE * delta:
		update_wander()
	
func chase(delta):
	var player = playerDetectionZone.player
	if player != null:
		accelerate_towards_point(player.global_position, delta)			
	else:
		state = IDLE

func update_wander_target_position():
	var wanderTargetPos = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))
	wanderTargetPos = wanderStartPos + wanderTargetPos

func check_wander_timer():
	if wanderTimer.time_left == 0:
		update_wander()
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	
	wanderTimer.start(rand_range(1,3))
	print("wander timer: ", wanderTimer.time_left)

func accelerate_towards_point(point, delta):
	var direction = position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	move()
	

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


#func _on_EnemyStats_no_health():
#	randomCrystal.drop_crystal()
#	emit_signal("death_effect")
#	get_parent().queue_free()


