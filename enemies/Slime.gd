extends KinematicBody2D


enum ElementalCrystals {
	BLUE,
	GREEN
}

onready var crystal_sprite = $"AnimatedSprite Crystal"

var elementalCrystal

func _ready():
	randomize()
	random_element()

func _process(delta):
	pass
	
func random_element():
	var elementalCrystal = ElementalCrystals.keys()[randi() % ElementalCrystals.size()]
	print(elementalCrystal)
	crystal_sprite.play(str(elementalCrystal))
	
