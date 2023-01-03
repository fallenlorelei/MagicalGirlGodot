extends Node2D


var crystalsLight = 0
var crystalsDark  = 0
var crystalsPsychic = 0
var crystalsWater = 0
var crystalsFire = 0
var crystalsIce = 0
var crystalsEarth = 0
var crystalsThunder = 0

signal crystals_changed

func update_crystals(element, amount):
	match element:
		"BLUE":
			crystalsWater += 1			
		"GREEN":
			crystalsEarth += 1			
		"PINK":
			crystalsPsychic += 1			
		"PURPLE":
			crystalsDark += 1			
		"RED":
			crystalsFire += 1
			
	emit_signal("crystals_changed")
