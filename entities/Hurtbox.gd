extends Area2D

const HitEffect = preload("res://abilities/HitEffectParticles.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func _physics_process(_delta):
	pass

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	
func create_hit_effect(ability, object):
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	effect.object = object
	effect.ability = ability
	main.add_child(effect)
	effect.global_position = global_position
	

func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)

func _on_Hurtbox_invincibility_ended():
	monitoring = true
