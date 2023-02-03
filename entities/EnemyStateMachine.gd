extends "res://scripts/StateMachine.gd"

func _ready():
	add_state("IDLE")
	add_state("WANDER")
	add_state("CHASE")
	add_state("MELEE_ATTACK")
	add_state("DYING")
	add_state("DEAD")
	call_deferred("set_state", states.IDLE)

func _state_logic(delta):
	parent.move(delta)
	match state:
		states.IDLE:
			parent.idle_state(delta)
		
		states.WANDER:
			parent.wander_state(delta)
			
		states.CHASE:
			parent.start_chasing_player(delta)
		
		states.MELEE_ATTACK:
			parent.melee_attack()
			
		states.DYING:
			parent.dying_state()
			
	
func _get_transition(delta):
	match state:
		states.IDLE:
			if parent._on_EnemyStats_died():
				return states.DYING
			if parent.playerDetectionZone.can_see_player() && !parent.softCollision.is_colliding():
				return states.CHASE
			match parent.random_state:
				states.WANDER:
					return states.WANDER
			
		states.WANDER:
			if parent._on_EnemyStats_died():
				return states.DYING
			if parent.playerDetectionZone.can_see_player() && !parent.softCollision.is_colliding():
				return states.CHASE
			match parent.random_state:
				states.IDLE:
					return states.IDLE
				
		states.CHASE:
			if parent._on_EnemyStats_died():
				return states.DYING
			if parent.softCollision.is_colliding():
				return states.WANDER
			if parent.check_range() && parent.player.dead == false:
				return states.MELEE_ATTACK
			if !parent.playerDetectionZone.can_see_player():
				return states.WANDER
			if parent.player.dead == true:
				return states.WANDER
		
		states.MELEE_ATTACK:
			if parent._on_EnemyStats_died():
				return states.DYING
			if parent.softCollision.is_colliding():
				return states.WANDER
			if parent.beginAttack == false:
				return states.IDLE
			if !parent.check_range():
				return states.IDLE
				
		states.DYING:
			pass
			
	
func _enter_state(new_state, old_state):
	match state:
		states.IDLE:
			parent.animationState.travel("Idle")
		states.WANDER:
			parent.animationState.travel("Idle")
		states.CHASE:
			parent.animationState.travel("Idle")
		states.MELEE_ATTACK:
			parent.animationState.travel("Melee_Attack")
		states.DYING:
			parent.animationState.travel("Dying")
	
func _exit_state(old_state, new_state):
	pass
