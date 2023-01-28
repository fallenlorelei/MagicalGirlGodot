extends "res://StateMachine.gd"

func _ready():
	add_state("IDLE")
	add_state("MOVE")
	add_state("JUMP")
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
		states.CASTING:
			parent.casting_state()
		states.DYING:
			parent.dying_state()

#MOVING FROM ONE STATE TO ANOTHER
func _get_transition(_delta):
	match state:
		states.IDLE:
			if parent.begin_dying():
				return states.DYING
			if parent.check_input() == "left_click" && parent.mouse_over_ui == false:
				return states.CASTING
			if parent.check_input() == "using_skill" && parent.attackManager.check_global_cooldown():
				return states.CASTING
			if parent.check_input() == "jump":
				return states.JUMP	
			if parent.check_input() == "moving":
				return states.MOVE	

		states.MOVE:
			if parent.begin_dying():
				return states.DYING
			if parent.check_input() == "left_click" && parent.mouse_over_ui == false:
				return states.CASTING
			if parent.check_input() == "using_skill" && parent.attackManager.check_global_cooldown():
				return states.CASTING
			if parent.check_input() == "jump":
				return states.JUMP	
			if parent.velocity == Vector2.ZERO:
				return states.IDLE

		states.JUMP:
			if parent.begin_dying():
				return states.DYING
			if parent.jumpFinished == true:
				return states.IDLE

		states.CASTING:
			if parent.begin_dying():
				return states.DYING
			if parent.attackFinished == true && parent.attackManager.attackAnimationTimer.is_stopped():
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
		states.CASTING:
			parent.update_input_vector()
		states.DYING:
			parent.animationState.travel("death")
	
func _exit_state(old_state, new_state):
	match old_state:
		states.JUMP:
			parent.jumpFinished = false
			parent.reset_collision_masks()
		states.CASTING:
			parent.attackFinished = false
