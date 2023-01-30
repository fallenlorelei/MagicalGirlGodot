extends Control

onready var crystalCounters = ElementalCrystalCounter.crystals

onready var crystalUi = {
	"LIGHT": $"%LightAmount",
	"DARK": $"%DarkAmount",
	"PSYCHIC": $"%PsychicAmount",
	"WATER": $"%WaterAmount",
	"FIRE": $"%FireAmount",
	"ICE": $"%IceAmount",
	"EARTH": $"%EarthAmount",
	"THUNDER": $"%ThunderAmount",
	"WIND": $"%WindAmount"
}

onready var crystalProgressUI = {
	"LIGHT": $"%LightProgress",
	"DARK": $"%DarkProgress",
	"PSYCHIC": $"%PsychicProgress",
	"WATER": $"%WaterProgress",
	"FIRE": $"%FireProgress",
	"ICE": $"%IceProgress",
	"EARTH": $"%EarthProgress",
	"THUNDER": $"%ThunderProgress",
	"WIND": $"%WindProgress"
}


onready var mouseOpenDetection = $TextureRect/MouseDetection_Open

var mouseOverLock = false
var windowOpen = false
var lockedOpen = false

func _ready():
	ElementalCrystalCounter.connect("crystals_changed", self, "update_crystals")
	set_text()

func set_text():
	var maxCrystals = ElementalCrystalCounter.most_crystals()

	for crystal in crystalCounters:
		crystalUi[crystal].text = str(crystalCounters[crystal])
		
		var TW = get_tree().create_tween()
		TW.tween_property(crystalProgressUI[crystal], "value", float(crystalCounters[crystal]), .2)
		TW.tween_property(crystalProgressUI[crystal], "max_value", float(maxCrystals), .2)
			
func update_crystals():
	set_text()


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
			TW.tween_property(self, "rect_position:x", -140.0, .2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			yield(get_tree().create_timer(0.2), "timeout")
			mouseOpenDetection.show()

func _on_LockButton_toggled(button_pressed):
	if button_pressed == true and windowOpen == true:
		lockedOpen = true
	if button_pressed == false and windowOpen == true:
		lockedOpen = false
	if button_pressed == true and windowOpen == false:
		lockedOpen = true
	if button_pressed == false and windowOpen == false:
		lockedOpen = false

func _on_LockButton_mouse_entered():
	mouseOverLock = true
	SignalBus.emit_signal("mouseOverLock", true)

func _on_LockButton_mouse_exited():
	mouseOverLock = false
	SignalBus.emit_signal("mouseOverLock", false)
	_on_MouseDetection_Close_mouse_exited()
