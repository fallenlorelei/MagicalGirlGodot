extends "res://entities/EntityBase.gd"

onready var sprite = $Sprite
onready var collisionShape = $CollisionShape2D
onready var hitbox = $HitboxPivot/Hitbox
onready var hitboxPivot = $HitboxPivot
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderTimer = $WanderTimer
onready var randomCrystal = $RandomCrystal
onready var hpBar = $HPBar
onready var enemyStateMachine = $EnemyStateMachine
onready var wanderStartPos = global_position
onready var wanderTargetPos = global_position
onready var TOLERANCE = sprite.texture.get_width() / 2

export(int) var wander_range = 80

var direction = Vector2()
var beginAttack = false
var player = KinematicBody2D
var enemyDied = false
var random_state

func _ready():
	enemyStats = $EnemyStats
	enemyStats.hpBar = hpBar
	enemyStats.hp = enemyStats.hp_max
	hpBar.hide()
	
	animationTree.active = true
	
	update_wander_target_position()

func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)					
	if wanderTimer.time_left == 0:
		check_wander_timer()

# == WANDERING AND MOVING ==
func wander_state(delta):
	if wanderTimer.time_left == 0:
		check_wander_timer()
	accelerate_towards_point(wanderTargetPos, delta)
	
# Soft collision is so enemies don't overlap each other
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * ACCELERATION
		move(delta)
		
# This keeps the slime from overshooting its target position and running back and forth
	if global_position.distance_to(wanderTargetPos) <= TOLERANCE:
		update_wander_timer()

# Randomly walking around
func update_wander_target_position():
	var wanderTargetVector = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))
	wanderTargetPos = wanderStartPos + wanderTargetVector

# Moving to destination (random target, or player)
func accelerate_towards_point(wander_TargetPos, delta):
	direction = global_position.direction_to(wander_TargetPos)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0

# == CHASING ==
func start_chasing_player(delta):
	player = playerDetectionZone.player
	if player != null:
		accelerate_towards_point(player.global_position, delta)

func check_range():
	var collisionSize = get_node("CollisionShape2D").shape.height
	var hitboxSize = hitbox.get_node("CollisionShape2D").shape.radius
	var attackDistance = collisionSize + hitboxSize
	
	if is_instance_valid(player):
		if global_position.distance_to(player.global_position) <= attackDistance:
			return true

#== ATTACKING ==
func melee_attack():
	if direction.x >= 0:
		hitboxPivot.rotation_degrees = 90
	else:
		hitboxPivot.rotation_degrees = 0

# == WANDER TIMER ==
func check_wander_timer():
	if wanderTimer.time_left == 0:
		update_wander_target_position()
		update_wander_timer()
	
func update_wander_timer():
	pick_random_state([enemyStateMachine.states.IDLE, enemyStateMachine.states.WANDER])
	wanderTimer.start(rand_range(1,3))
	
func pick_random_state(state_list):
	random_state = state_list[randi()%state_list.size()]
	
# == TAKING DAMAGE ==	
func _on_EnemyStats_hp_changed(new_hp):
	enemyStats.hpBarUpdate(new_hp)

# == DYING ==
func _on_EnemyStats_died():
	if enemyStats.hp == 0:
		return true

func dying_state():
	collisionShape.set_deferred("disabled",true)
	hpBar.hide()
	hurtbox.monitoring = false
	hitbox.monitorable = false
	velocity = Vector2.ZERO
	
	if is_instance_valid(randomCrystal):
		randomCrystal.drop()
		randomCrystal.queue_free()
		
func death_animation_finished():
	queue_free()
