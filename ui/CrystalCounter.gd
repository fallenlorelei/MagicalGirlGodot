extends Control

signal mouseOverLock

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

onready var mouseOpenDetection = $TextureRect/MouseDetection_Open

var mouseOverLock = false
var windowOpen = false
var lockedOpen = false

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
	
	var crystalListMax = crystalList.max()
	
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
	
	lightProgress.max_value = crystalListMax
	darkProgress.max_value = crystalListMax
	psychicProgress.max_value = crystalListMax
	waterProgress.max_value = crystalListMax
	fireProgress.max_value = crystalListMax
	iceProgress.max_value = crystalListMax
	earthProgress.max_value = crystalListMax
	thunderProgress.max_value = crystalListMax

func update_crystals():
	set_text()

func _on_TextureButton_toggled(button_pressed):
	if button_pressed == true and windowOpen == true:
		lockedOpen = true
	if button_pressed == false and windowOpen == true:
		lockedOpen = false
	if button_pressed == true and windowOpen == false:
		lockedOpen = true
	if button_pressed == false and windowOpen == false:
		lockedOpen = false


func _on_MouseDetection_Open_mouse_entered():
	yield(get_tree().create_timer(0.2), "timeout")
	if lockedOpen == false:
		windowOpen = true
		var TW = get_tree().create_tween()
		TW.tween_property(self, "rect_position:x", 0.0, .3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		mouseOpenDetection.hide()

func _on_MouseDetection_Close_mouse_exited():
	if lockedOpen == false and windowOpen == true:
		yield(get_tree().create_timer(0.2), "timeout")		
		if mouseOverLock == false:
			windowOpen = false
			var TW = get_tree().create_tween()
			TW.tween_property(self, "rect_position:x", -165.0, .2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			yield(get_tree().create_timer(0.2), "timeout")
			mouseOpenDetection.show()

func _on_TextureButton_mouse_entered():
	mouseOverLock = true
	emit_signal("mouseOverLock")

func _on_TextureButton_mouse_exited():
	mouseOverLock = false
	emit_signal("mouseOverLock")
	_on_MouseDetection_Close_mouse_exited()
