extends Area2D

const CrystalDrop = preload("res://items/CrystalDrop.tscn")

onready var randomCrystalScript = $RandomizeCrystal

func _ready():
	pass

func drop():
	var randomDropAmount = pick_random()
	for i in randomDropAmount:
		var crystalDrop = CrystalDrop.instance()
		crystalDrop.crystalType = randomCrystalScript.elementalCrystal
		get_parent().get_parent().call_deferred("add_child", crystalDrop)
		crystalDrop.global_position = global_position

func pick_random():
	var nums = [1,1,1,1,2,2,3] #list to choose from
	return nums[randi() % nums.size()]
