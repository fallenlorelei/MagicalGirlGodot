extends "res://StateMachine.gd"

func _ready():
	add_state("IDLE")
	add_state("MOVE")
	add_state("JUMP")
	add_state("BEGIN_CAST")
	add_state("CASTING")
	add_state("DYING")
	call_deferred("set_state", states.IDLE)

func _state_logic(delta):
	parent.check_input()
	parent.get_cursor_info()
	parent.move(delta)
	
	match state:
		states.IDLE:
			parent.idle_state(delta)
		states.MOVE:
			parent.move_state(delta)
		states.JUMP:
			parent.jump_state(delta)
		states.BEGIN_CAST:
			parent.begin_cast()
		states.CASTING:
			parent.casting()
		states.DYING:
			parent.dying_state()

#MOVING FROM ONE STATE TO ANOTHER
func _get_transition(_delta):
	match state:
		states.IDLE:
			if parent.begin_dying():
				return states.DYING
			if parent.check_input() == "using_skill" && parent.mouse_over_ui == false && parent.attackManager.check_global_cooldown():
				return states.BEGIN_CAST
			if parent.check_input() == "jump":
				return states.JUMP	
			if parent.check_input() == "moving":
				return states.MOVE	

		states.MOVE:
			if parent.begin_dying():
				return states.DYING
			if parent.check_input() == "using_skill" && parent.mouse_over_ui == false && parent.attackManager.check_global_cooldown():
				return states.BEGIN_CAST
			if parent.check_input() == "jump":
				return states.JUMP	
			if parent.velocity == Vector2.ZERO:
				return states.IDLE

		states.JUMP:
			if parent.begin_dying():
				return states.DYING
			if parent.jumpFinished == true:
				return states.IDLE
		
		states.BEGIN_CAST:
			if parent.begin_dying():
				return states.DYING
			if parent.releaseAbility == true:
				return states.CASTING
			if parent.cancelled == true:
				return states.IDLE
				
		states.CASTING:
			if parent.begin_dying():
				return states.DYING
			if parent.attackAnimationFinished == true:
				return states.IDLE
		
		states.DYING:
			pass
			
func _enter_state(new_state, old_state):
	match new_state:
		states.IDLE:
			parent.animationState.travel("Idle")
		states.MOVE:
			parent.animationState.travel("Run")
		states.JUMP:
			parent.update_input_vector()
			parent.animationState.travel("Jump")
		states.BEGIN_CAST:
			parent.update_input_vector()
		states.CASTING:
			parent.animationState.travel("Attack")
			parent.update_input_vector()
		states.DYING:
			parent.animationState.travel("death")
	
func _exit_state(old_state, new_state):
	match old_state:
		states.JUMP:
			parent.jumpFinished = false
			parent.reset_collision_masks()
