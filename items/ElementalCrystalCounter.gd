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
			crystalsWater += amount			
		"GREEN":
			crystalsEarth += amount			
		"PINK":
			crystalsPsychic += amount			
		"PURPLE":
			crystalsDark += amount			
		"RED":
			crystalsFire += amount
			
	emit_signal("crystals_changed")
