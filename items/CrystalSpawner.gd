extends Node2D

# Need to make a "Crystal Spawner" be separate from "Crystal Drop"

onready var animatedCrystal = $AnimatedSpriteCrystal
var crystalType

func _ready():
	print(crystalType)
	animatedCrystal.play(str(crystalType))
