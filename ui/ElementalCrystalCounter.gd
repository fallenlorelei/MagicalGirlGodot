extends Node2D

var crystals = {
	"LIGHT": 0,
	"DARK": 0,
	"PSYCHIC": 0,
	"WATER": 0,
	"FIRE": 0,
	"ICE": 0,
	"EARTH": 0,
	"THUNDER": 0, 
}

signal crystals_changed

# This could be replaced by a max crystal var that is checked on crystals_changed
func most_crystals():
	var most = 0
	for crystal in crystals:
		if crystals[crystal] > most:
			most = crystals[crystal]
	return most

func update_crystals(element, amount):
	match element:
		"BLUE":
			crystals["WATER"] += amount			
		"GREEN":
			crystals["EARTH"] += amount			
		"PINK":
			crystals["PSYCHIC"] += amount			
		"PURPLE":
			crystals["DARK"] += amount			
		"RED":
			crystals["FIRE"] += amount
			
	emit_signal("crystals_changed")
