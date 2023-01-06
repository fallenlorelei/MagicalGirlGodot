extends Node2D

var velocity = Vector2()
#var parent = get_parent()

func execute(parent):
	
	if parent.input_vector != Vector2.ZERO:
		velocity = parent.input_vector * parent.JUMP_SPEED
	else:
		velocity = parent.jump_vector * parent.JUMP_SPEED
		
	parent.animationState.travel("Jump")
	velocity = parent.move_and_slide(velocity)
	
	# Sets collision mask so that girl can jump through enemies
	# This is reset when jump animation is finished
	# Current problem: I would like the slimes to still "see" her when she's jumping, to chase, just not collide
	parent.set_collision_layer_bit(1, false)
	parent.set_collision_layer_bit(4, true)
	parent.set_collision_mask_bit(2, false)
	parent.hurtbox.set_collision_layer_bit(5, false)

func landed(_parent):
	velocity = Vector2.ZERO
	
func animation_finished(parent):
	velocity = Vector2.ZERO
	parent.set_collision_layer_bit(1, true)
	parent.set_collision_layer_bit(4, false)
	parent.set_collision_mask_bit(2, true)
	parent.hurtbox.set_collision_layer_bit(5, true)
	parent.state = 0
