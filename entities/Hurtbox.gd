extends Area2D

const HitEffect = preload("res://abilities/HitEffectParticles.tscn")

var invincible = false setget set_invincible
var invincibleDuration = .5

onready var timer = $InvincibilityTimer

func _physics_process(_delta):
	pass

func on_hit(targetAttacked, skillUsed):
	self.invincible = true
	get_parent().on_hit(targetAttacked, skillUsed)

func heal(healAmount):
	get_parent().skillManager.heal(healAmount)
	
func create_hit_effect(ability, object, abilityparent):
	var effect = HitEffect.instance()
	effect.objectHit = object
	effect.abilityUsed = ability
	effect.abilityParent = abilityparent
	effect.global_position = global_position
	add_child(effect)

func set_invincible(value):
	invincible = value
	if invincible == true:
		timer.start(invincibleDuration)
		set_deferred("monitoring", false)

func _on_InvincibilityTimer_timeout():
	monitoring = true
	self.invincible = false
	print("done")
