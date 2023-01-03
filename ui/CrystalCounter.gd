extends Control

onready var crystalCounter = ElementalCrystalCounter
onready var crystalsEarth = $HBoxContainer/EarthCrystals
onready var crystalsWater = $HBoxContainer/WaterCrystals
onready var crystalsPsychic = $HBoxContainer/PsychicCrystals
onready var crystalsDark = $HBoxContainer/DarkCrystals
onready var crystalsFire = $HBoxContainer/FireCrystals

func _ready():
	crystalCounter.connect("crystals_changed", self, "update_crystals")
	set_text()

func set_text():
	crystalsEarth.text = str("Earth: ", crystalCounter.crystalsEarth)
	crystalsWater.text = str("Water: ", crystalCounter.crystalsWater)
	crystalsPsychic.text = str("Psychic: ", crystalCounter.crystalsPsychic)
	crystalsDark.text = str("Dark: ", crystalCounter.crystalsDark)
	crystalsFire.text = str("Fire: ", crystalCounter.crystalsFire)

func update_crystals():
	set_text()
