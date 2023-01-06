extends Control

onready var crystalCounter = ElementalCrystalCounter
onready var crystalsLight = $"%LightCrystals"
onready var crystalsDark = $"%DarkCrystals"
onready var crystalsPsychic = $"%PsychicCrystals"
onready var crystalsWater = $"%WaterCrystals"
onready var crystalsFire = $"%FireCrystals"
onready var crystalsIce = $"%IceCrystals"
onready var crystalsEarth = $"%EarthCrystals"
onready var crystalsThunder = $"%ThunderCrystals"

func _ready():
	crystalCounter.connect("crystals_changed", self, "update_crystals")
	set_text()

func set_text():
	crystalsLight.text = str("Light: ", crystalCounter.crystalsLight)
	crystalsDark.text = str("Dark: ", crystalCounter.crystalsDark)
	crystalsPsychic.text = str("Psychic: ", crystalCounter.crystalsPsychic)
	crystalsWater.text = str("Water: ", crystalCounter.crystalsWater)	
	crystalsFire.text = str("Fire: ", crystalCounter.crystalsFire)
	crystalsIce.text = str("Ice: ", crystalCounter.crystalsIce)
	crystalsEarth.text = str("Earth: ", crystalCounter.crystalsEarth)
	crystalsThunder.text = str("Thunder: ", crystalCounter.crystalsThunder)

func update_crystals():
	set_text()
