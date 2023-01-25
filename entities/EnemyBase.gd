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
	
	add_state("IDLE")
	add_state("WANDER")
	add_state("CHASE")
	add_state("MELEE_ATTACK")
	add_state("DYING")
	add_state("DEAD")
	call_deferred("set_state", states.IDLE)
	
	update_wander_target_position()

# == STATE MACHINE ==
func _state_logic(delta):
	move(delta)
	match state:
		states.IDLE:
			idle_state(delta)
		
		states.WANDER:
			wander_state(delta)
			
		states.CHASE:
			start_chasing_player(delta)
		
		states.MELEE_ATTACK:
			melee_attack()
			
		states.DYING:
			dying_state()
			
	
func _get_transition(delta):
	match state:
		states.IDLE:
			if _on_EnemyStats_died():
				return states.DYING
			if playerDetectionZone.can_see_player() && !softCollision.is_colliding():
				return states.CHASE
			match random_state:
				states.WANDER:
					return states.WANDER
			
		states.WANDER:
			if _on_EnemyStats_died():
				return states.DYING
			if playerDetectionZone.can_see_player() && !softCollision.is_colliding():
				return states.CHASE
			match random_state:
				states.IDLE:
					return states.IDLE
				
		states.CHASE:
			if _on_EnemyStats_died():
				return states.DYING
			if softCollision.is_colliding():
				return states.WANDER
			if check_range() && player.dead == false:
				return states.MELEE_ATTACK
			if !playerDetectionZone.can_see_player():
				return states.IDLE
			if player.dead == true:
				return states.WANDER
		
		states.MELEE_ATTACK:
			if _on_EnemyStats_died():
				return states.DYING
			if softCollision.is_colliding():
				return states.WANDER
			if beginAttack == false:
				return states.IDLE
			if !check_range():
				return states.IDLE
				
		states.DYING:
			pass
			
	
func _enter_state(new_state, old_state):
	match state:
		states.IDLE:
			animationState.travel("Idle")
		states.WANDER:
			animationState.travel("Idle")
		states.CHASE:
			animationState.travel("Idle")
		states.MELEE_ATTACK:
			animationState.travel("Melee_Attack")
		states.DYING:
			animationState.travel("Dying")
	
func _exit_state(old_state, new_state):
	pass

# ======================

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
	pick_random_state([states.IDLE, states.WANDER])
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
