extends Area2D

const CrystalDrop = preload("res://items/CrystalDrop.tscn")

onready var randomCrystalScript = $RandomizeCrystal


func _ready():
	pass

func drop_crystal():
	var crystalDrop = CrystalDrop.instance()
	crystalDrop.crystalType = randomCrystalScript.elementalCrystal
	get_parent().get_parent().call_deferred("add_child", crystalDrop)
	crystalDrop.global_position = global_position
	
