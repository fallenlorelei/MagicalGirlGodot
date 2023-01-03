extends Node2D

#export(String, "BLUE","GREEN","PINK","PURPLE","RED") var ElementalCrystals

onready var randomCrystalSprite = $"../AnimatedSpriteCrystal"

var elementalCrystal

enum ElementalCrystals {
	BLUE,
	GREEN,
	PINK,
	PURPLE,
	RED
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
	spawned = true
