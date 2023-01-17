extends Node2D

#export(String, "BLUE","GREEN","PINK","PURPLE","RED") var ElementalCrystals

onready var randomCrystalSprite = $"../ElementalCrystalSprite"
onready var randomCrystalAnimation = $"../ElementalCrystalSprite/AnimationPlayer"

var elementalCrystal
var elementalCrystalSpriteFrame

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

	match elementalCrystal:
		"LIGHT": elementalCrystalSpriteFrame = 6
		"DARK": elementalCrystalSpriteFrame = 7
		"PSYCHIC": elementalCrystalSpriteFrame = 5
		"FIRE": elementalCrystalSpriteFrame = 0
		"ICE": elementalCrystalSpriteFrame = 1
		"THUNDER": elementalCrystalSpriteFrame = 2
		"WATER": elementalCrystalSpriteFrame = 3
		"EARTH": elementalCrystalSpriteFrame = 4

	randomCrystalSprite.frame = int(elementalCrystalSpriteFrame)
	randomCrystalAnimation.advance(rand_range(0,.8))
	spawned = true
