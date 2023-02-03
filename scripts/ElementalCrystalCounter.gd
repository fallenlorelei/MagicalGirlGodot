extends Node2D

var crystals = {
	"LIGHT": 10,
	"DARK": 0,
	"PSYCHIC": 0,
	"WATER": 0,
	"FIRE": 0,
	"ICE": 0,
	"EARTH": 0,
	"THUNDER": 0, 
	"WIND": 0, 
}

var crystalAnimationFrame = {
	"LIGHT": 6,
	"DARK": 7,
	"PSYCHIC": 8,
	"FIRE": 0,
	"ICE": 1,
	"THUNDER": 2,
	"WATER": 3,
	"EARTH": 4,
	"WIND": 5,
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
		"LIGHT":
			crystals["LIGHT"] += amount
		"DARK":
			crystals["DARK"] += amount
		"PSYCHIC":
			crystals["PSYCHIC"] += amount
		"FIRE":
			crystals["FIRE"] += amount
		"ICE":
			crystals["ICE"] += amount
		"EARTH":
			crystals["EARTH"] += amount
		"THUNDER":
			crystals["THUNDER"] += amount
		"WATER":
			crystals["WATER"] += amount
		"WIND":
			crystals["WIND"] += amount

	emit_signal("crystals_changed")
