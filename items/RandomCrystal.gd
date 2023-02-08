extends Area2D

const CrystalDrop = preload("res://items/CrystalDrop.tscn")

export var minDrops = 1
export var maxDrops = 4

onready var randomCrystalScript = $RandomizeCrystal

func _ready():
	pass

func drop():
	var randomDropAmount = rand_range(minDrops, maxDrops)
	for i in randomDropAmount:
		var crystalDrop = CrystalDrop.instance()
		crystalDrop.crystalType = randomCrystalScript.elementalCrystal
		get_parent().get_parent().call_deferred("add_child", crystalDrop)
		crystalDrop.global_position = global_position
	
