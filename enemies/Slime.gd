extends KinematicBody2D


enum ElementalCrystals {
	BLUE,
	GREEN,
	PINK,
	PURPLE,
	RED
}

onready var crystal_sprite = $AnimatedSpriteCrystal


func _ready():
	random_element()

func _process(delta):
	pass
	
func random_element():
	var elementalCrystal = ElementalCrystals.keys()[randi() % ElementalCrystals.size()]
	print(elementalCrystal)
	crystal_sprite.play(str(elementalCrystal))
	
