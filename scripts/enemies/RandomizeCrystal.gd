extends Node2D

onready var randomCrystalSprite = $"../ElementalCrystalSprite"
onready var randomCrystalAnimation = $"../ElementalCrystalSprite/AnimationPlayer"
onready var crystalCounter = ElementalCrystalCounter

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
	randomCrystalSprite.frame = int(crystalCounter.crystalAnimationFrame[elementalCrystal])
	randomCrystalAnimation.advance(rand_range(0,.8))
	spawned = true
