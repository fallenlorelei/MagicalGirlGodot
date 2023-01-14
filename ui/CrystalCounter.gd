extends Control

onready var crystalCounter = ElementalCrystalCounter
onready var crystalsLight = $"%LightAmount"
onready var crystalsDark = $"%DarkAmount"
onready var crystalsPsychic = $"%PsychicAmount"
onready var crystalsFire = $"%FireAmount"
onready var crystalsIce = $"%IceAmount"
onready var crystalsEarth = $"%EarthAmount"
onready var crystalsThunder = $"%ThunderAmount"
onready var crystalsWater = $"%WaterAmount"

onready var lightProgress = $"%LightProgress"
onready var darkProgress = $"%DarkProgress"
onready var psychicProgress = $"%PsychicProgress"
onready var fireProgress = $"%FireProgress"
onready var iceProgress = $"%IceProgress"
onready var earthProgress = $"%EarthProgress"
onready var thunderProgress = $"%ThunderProgress"
onready var waterProgress = $"%WaterProgress"

func _ready():
	crystalCounter.connect("crystals_changed", self, "update_crystals")
	set_text()

func set_text():
	var crystalList = [
		crystalCounter.crystalsLight,
		crystalCounter.crystalsDark,
		crystalCounter.crystalsPsychic,
		crystalCounter.crystalsWater,
		crystalCounter.crystalsFire,
		crystalCounter.crystalsIce,
		crystalCounter.crystalsEarth,
		crystalCounter.crystalsThunder
	]
	
	crystalsLight.text = str(crystalCounter.crystalsLight)
	crystalsDark.text = str(crystalCounter.crystalsDark)
	crystalsPsychic.text = str(crystalCounter.crystalsPsychic)
	crystalsWater.text = str(crystalCounter.crystalsWater)	
	crystalsFire.text = str(crystalCounter.crystalsFire)
	crystalsIce.text = str(crystalCounter.crystalsIce)
	crystalsEarth.text = str(crystalCounter.crystalsEarth)
	crystalsThunder.text = str(crystalCounter.crystalsThunder)
	
	lightProgress.value = crystalCounter.crystalsLight
	darkProgress.value = crystalCounter.crystalsDark
	psychicProgress.value = crystalCounter.crystalsPsychic
	waterProgress.value = crystalCounter.crystalsWater
	fireProgress.value = crystalCounter.crystalsFire
	iceProgress.value = crystalCounter.crystalsIce
	earthProgress.value = crystalCounter.crystalsEarth
	thunderProgress.value = crystalCounter.crystalsThunder
	
	lightProgress.max_value = crystalList.max()
	darkProgress.max_value = crystalList.max()
	psychicProgress.max_value = crystalList.max()
	waterProgress.max_value = crystalList.max()
	fireProgress.max_value = crystalList.max()
	iceProgress.max_value = crystalList.max()
	earthProgress.max_value = crystalList.max()
	thunderProgress.max_value = crystalList.max()

func update_crystals():
	set_text()

func _on_Container_mouse_entered():
	yield(get_tree().create_timer(0.2), "timeout")
	var TW = get_tree().create_tween()
	TW.tween_property(self, "rect_position:x", 0.0, .3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
func _on_Container_mouse_exited():
	var TW = get_tree().create_tween()
	TW.tween_property(self, "rect_position:x", -165.0, .2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
