extends Node2D

var scene
var currentAttacks = {}

onready var attack_origin = $AttackOrigin

func _ready():
	scene = preload("res://Attacks//ShootAttack.tscn")

# 
# orgin : Can pass offset of 
# 
func attack(id, attack_type, timing):
	# Use htis to switch attack_type to correct function
	var current_time = Time.get_ticks_msec()
	if !(id in currentAttacks):
		currentAttacks[id] = {}
		currentAttacks[id]["attack_type"] = attack_type
		currentAttacks[id]["timing"] = timing
		currentAttacks[id]["last_play"] = -1000
		
	if id in currentAttacks and current_time - currentAttacks[id]['last_play'] > currentAttacks[id]['timing']:
		var instance = scene.instance()
		instance.position = attack_origin.position
		add_child(instance)
		currentAttacks[id]["last_play"] = Time.get_ticks_msec()

#TODO ON DESTROY REMOVE FROM CURRENT ATTACKS
