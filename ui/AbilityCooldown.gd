extends "res://ui/SkillbarButtons.gd"

onready var cooldownProgress = $Cooldown
onready var cooldownTimer = $Timer
onready var cooldownLabel = $Label

var cooldownDuration
var onCooldown = false

func _ready():
	pass

func start_cooldown(cooldown):
	cooldownDuration = cooldown
	cooldownTimer.wait_time = cooldownDuration
	cooldownTimer.start()
	cooldownLabel.show()
	cooldownProgress.show()
	onCooldown = true

func _physics_process(delta):
	if cooldownTimer.time_left > 0:
		var cooldownPercentageLeft = cooldownTimer.time_left/cooldownDuration
		var durationToDegrees = cooldownPercentageLeft * 360
		cooldownLabel.text = str(stepify(cooldownTimer.time_left, .1))
		cooldownProgress.radial_fill_degrees = durationToDegrees

func _on_Timer_timeout():
	cooldownProgress.hide()
	cooldownLabel.hide()
	onCooldown = false
	var TW = get_tree().create_tween()
	TW.tween_property(get_parent(),"rect_scale",Vector2(1.2,1.2), .2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	TW.tween_property(get_parent(),"rect_scale",Vector2(1,1), .3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
