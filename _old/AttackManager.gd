extends Node2D

var scenes = {}
var currentAttacks = {}

onready var attack_origin = $AttackOrigin

func _ready():
	scenes = {
		'shootAttack': preload("res://attacks//ShootAttack.tscn"),
		'staticAttack': preload("res://attacks//StaticAttack.tscn"),
	}
# 
#  
# 
func attack(id, attack_type, timing, params = {}):
	# Use htis to switch attack_type to correct function
	var current_time = Time.get_ticks_msec()
	if !(id in currentAttacks):
		currentAttacks[id] = {}
		currentAttacks[id]["attack_type"] = attack_type
		currentAttacks[id]["timing"] = timing
		currentAttacks[id]["last_play"] = -1000
		
	if id in currentAttacks and current_time - currentAttacks[id]['last_play'] > currentAttacks[id]['timing']:
		var instance = scenes[attack_type].instance()
		if 'origin' in params.keys():
			instance.global_position = params['origin']
		get_parent().get_parent().add_child(instance)
		currentAttacks[id]["last_play"] = Time.get_ticks_msec()

#TODO At some point this method will need cleanup so the array doesn't grow like crazy
