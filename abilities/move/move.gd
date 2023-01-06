extends Node2D

var velocity = Vector2()

func execute(parent):
	if parent.attackManager.attackAnimationTimer.is_stopped():
		if parent.input_vector != Vector2.ZERO:
			parent.jump_vector = parent.input_vector
	#		
			parent.animationTree.set("parameters/Idle/blend_position", parent.input_vector)
			parent.animationTree.set("parameters/Run/blend_position", parent.input_vector)
			parent.animationTree.set("parameters/Jump/blend_position", parent.input_vector)
			
			parent.animationState.travel("Run")
			
			velocity = velocity.move_toward(parent.input_vector * parent.MAX_SPEED, parent.ACCELERATION)
			
		else:
			parent.animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, parent.FRICTION)

		velocity = parent.move_and_slide(velocity)
