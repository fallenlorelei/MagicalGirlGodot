extends "res://entities/EntityBase.gd"

onready var sprite = $Sprite
onready var hurtbox = $Hurtbox
onready var hitbox = $HitboxPivot/Hitbox
onready var hitboxPivot = $HitboxPivot
onready var animationPlayer = $AnimationPlayer
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderTimer = $WanderTimer
onready var randomCrystal = $RandomCrystal

onready var wanderStartPos = global_position
onready var wanderTargetPos = global_position

export(int) var TOLERANCE = 30
export(int) var wander_range = 80

var direction

func _ready():
	TOLERANCE = sprite.texture.get_width() / 2
	update_wander_target_position()
	state = WANDER
#	pick_random_state([IDLE, WANDER])
	
func _physics_process(delta):	
	match state:
		IDLE:
			idle(delta)
		WANDER:
			wander(delta)
		CHASE:
			chase(delta)
		DEAD:
			dead_state()
		
	seek_player()
	
# Soft collision is so enemies don't overlap each other
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400

func idle(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)					
	check_wander_timer()

# == WANDERING AND MOVING ==
func wander(delta):
	check_wander_timer()
	
	accelerate_towards_point(wanderTargetPos, delta)
	
# This keeps the slime from overshooting its target position and running back and forth
	if global_position.distance_to(wanderTargetPos) <= TOLERANCE:
		update_wander_timer()

func update_wander_target_position():
	var wanderTargetVector = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))
	wanderTargetPos = wanderStartPos + wanderTargetVector

func accelerate_towards_point(wanderTargetPos, delta):
	direction = global_position.direction_to(wanderTargetPos)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0
	move()

func seek_player():		
	if playerDetectionZone.can_see_player():
		state = CHASE
	
# == CHASING ==
func chase(delta):
	var player = playerDetectionZone.player
	if player != null:
		accelerate_towards_point(player.global_position, delta)
		var collisionSize = get_node("CollisionShape2D").shape.height
		var hitboxSize = hitbox.get_node("CollisionShape2D").shape.radius
		var attackDistance = collisionSize + hitboxSize
		if global_position.distance_to(player.global_position) <= attackDistance:
			state = attack()
	else:
		state = IDLE

#== ATTACKING ==
func attack():
	if direction.x > 0:
		hitboxPivot.rotation_degrees = 90
	animationPlayer.play("attack")
	
func attackAnimation_hitbox_on():
	hitbox.get_node("CollisionShape2D").disabled = false
	
func attackAnimation_hitbox_off():
	hitbox.get_node("CollisionShape2D").disabled = true
#	state = CHASE
	
# == WANDER TIMER ==
func check_wander_timer():
	if wanderTimer.time_left == 0:
		update_wander_target_position()
		update_wander_timer()
	
func update_wander_timer():
	pick_random_state([IDLE, WANDER])
	wanderTimer.start(rand_range(1,3))
	
func pick_random_state(state_list):
	state = state_list[randi()%state_list.size()]

func _on_WanderTimer_timeout():
	update_wander_target_position()

# == DYING ==
func dead_state():
	velocity = Vector2.ZERO
	hurtbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	if is_instance_valid(randomCrystal):
		randomCrystal.drop()
		
	if is_instance_valid(randomCrystal):
		randomCrystal.queue_free()
	animationPlayer.play("death")
	
func death_animation_finished():
	die()
