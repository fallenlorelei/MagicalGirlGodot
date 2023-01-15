extends Node2D

#export(String, "BLUE","GREEN","PINK","PURPLE","RED") var ElementalCrystals

onready var randomCrystalSprite = $"../ElementalCrystalSprite/AnimationPlayer"

var elementalCrystal

enum ElementalCrystals {
	LIGHT,
	DARK,
	PSYCHIC,
	FIRE,
	ICE,
	EARTH,
	THUNDER,
	WATER
}

var spawned = false

func _ready():
	if spawned == false:
		random_element()
	else:
		pass
	

func random_element():
	elementalCrystal = ElementalCrystals.keys()[randi() % ElementalCrystals.size()]
	randomCrystalSprite.play(str(elementalCrystal))
	randomCrystalSprite.seek(rand_range(0,.8),true)
	spawned = true
