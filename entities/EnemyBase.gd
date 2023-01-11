extends "res://entities/EntityBase.gd"

onready var sprite = $Sprite
onready var hurtbox = $Hurtbox
onready var hitbox = $HitboxPivot/Hitbox
onready var hitboxPivot = $HitboxPivot
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderTimer = $WanderTimer
onready var randomCrystal = $RandomCrystal

onready var wanderStartPos = global_position
onready var wanderTargetPos = global_position
onready var TOLERANCE = sprite.texture.get_width() / 2

export(int) var wander_range = 80

var direction
var beginAttack = false

func _ready():
	animationTree.active = true
	update_wander_target_position()
	state = WANDER
	
func _physics_process(delta):	
	match state:
		IDLE:
			idle(delta)
		WANDER:
			wander(delta)
		CHASE:
			chase(delta)
		DYING:
			dying_state()
		DEAD:
			dead_state()
		
	seek_player()
	
# Soft collision is so enemies don't overlap each other
	if softCollision.is_colliding() and beginAttack == false:
		velocity += softCollision.get_push_vector() * delta * ACCELERATION

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
	if playerDetectionZone.can_see_player() and state != DYING:
		state = CHASE
	
# == CHASING ==
func chase(delta):
	var player = playerDetectionZone.player

	if player != null and beginAttack == false:
		accelerate_towards_point(player.global_position, delta)
		
		if global_position.distance_to(player.global_position) <= check_range():
			velocity = velocity.move_toward(Vector2.ZERO, ATTACK_FRICTION)
			melee_attack()
	else:
		state = IDLE

func check_range():
	var collisionSize = get_node("CollisionShape2D").shape.height
	var hitboxSize = hitbox.get_node("CollisionShape2D").shape.radius
	var attackDistance = collisionSize + hitboxSize
	return attackDistance

#== ATTACKING ==
func melee_attack():
	beginAttack = true
	
	if direction.x >= 0:
		hitboxPivot.rotation_degrees = 90
	else:
		hitboxPivot.rotation_degrees = 0
		
	animationState.travel("Melee_Attack")
	
func attackAnimation_hitbox_on():
	hitbox.get_node("CollisionShape2D").disabled = false
	
func attackAnimation_hitbox_off():
	hitbox.get_node("CollisionShape2D").disabled = true
	beginAttack = false
	state = IDLE
	
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
func dying_state():
	hurtbox.monitoring = false
	hitbox.monitorable = false
	
	animationState.travel("Dying")
	velocity = Vector2.ZERO
	
	if is_instance_valid(randomCrystal):
		randomCrystal.drop()
		
	if is_instance_valid(randomCrystal):
		randomCrystal.queue_free()
		
func death_animation_finished():
	state = DEAD

func dead_state():
	animationState.travel("Dead")
	die()
	
func _on_EnemyBase_died():
	state = DYING
