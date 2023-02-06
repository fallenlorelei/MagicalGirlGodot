class_name EntityBase extends KinematicBody2D

onready var hurtbox = $Hurtbox


export(int) var ACCELERATION = 100
export(int) var MAX_SPEED = 120
export(int) var FRICTION = 100
export(int) var ATTACK_FRICTION = 100

var knockback = Vector2.ZERO
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var states = {}
var enemyStats
var playerStats

func _ready():
	pass

func _physics_process(delta):
	pass
	
func move(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	velocity = move_and_slide(velocity)

func on_hit(targetAttacked, skillUsed):
	if targetAttacked.is_in_group("Player"):
		playerAttacked(targetAttacked, skillUsed)
	elif targetAttacked.is_in_group("Enemy"):
		enemyAttacked(targetAttacked, skillUsed)
	
#	hurtbox.create_hit_effect(area, self, area.get_parent())

func playerAttacked(targetAttacked, skillUsed):
	if is_instance_valid(playerStats) and playerStats.hp > 0:
		playerStats.receive_damage(skillUsed.skillDamage)
		knockback = skillUsed.knockback_vector * skillUsed.knockbackModifier
	
func enemyAttacked(targetAttacked, skillUsed):
	if is_instance_valid(enemyStats) and enemyStats.hp > 0:
		enemyStats.receive_damage(skillUsed.skillDamage)
		knockback = skillUsed.knockback_vector * skillUsed.knockbackModifier

func update_player_hp_bar(hp, hp_max):
	SignalBus.emit_signal("update_player_hp_bar", hp, hp_max)
	SignalBus.emit_signal("shake_hp_bar")

func update_enemy_hp_bar(hp, hp_max):
	pass
	
