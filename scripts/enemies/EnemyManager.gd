extends Area2D

export var ACCELERATION = 200
export var MAX_SPEED = 20
export var FRICTION = 150
export var TOLERANCE = 60
export var invincibleDuration = .5

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
onready var stats = $EnemyStats
onready var randomCrystal = $RandomCrystal
onready var hurtbox = $Hurtbox

# There's a godot rule to "call down" and "signal up." 
# Can't move_and_slide this node, so I send a signal up.
signal start_movement
signal death_effect

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
#	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
#	knockback = move_and_slide(knockback)

	seek_player()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)					
			check_wander_timer()

			
		WANDER:			
			check_wander_timer()
			accelerate_towards_point(wanderController.target_position, delta)
			
			# This keeps the slime from overshooting its target position and running back and forth
			# "Tolerance" is a pretty random number that I think should be similar to half the sprite's width
			if global_position.distance_to(wanderController.target_position) <= TOLERANCE * delta:
				update_wander()

			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)			
			else:
				state = IDLE
			
	# Soft collision is enemies hitting each other and not overlapping
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400


#Wander timer updates every 1-3 seconds to change from wander to idle
func check_wander_timer():
	if wanderController.get_time_left() == 0:
		update_wander()
	
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


func _on_Hurtbox_area_entered(area):
	if hurtbox.invincible == false:
		stats.health -= area.damage
		hurtbox.start_invincibility(invincibleDuration)

func _on_EnemyStats_no_health():
	randomCrystal.drop_crystal()
	emit_signal("death_effect")
	get_parent().queue_free()
