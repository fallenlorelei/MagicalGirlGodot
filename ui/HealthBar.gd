extends Control

onready var tooltip = $HPTooltip
onready var hpLabel = $HPTooltip/Label
onready var background = $HPTooltip/Label/Background
onready var hpBarAnimation = $PlayerHPBar/AnimationPlayer

var screensize = OS.window_size
var adj_pos = Vector2()	
var playerAlive = true

func _ready():
	SignalBus.connect("shake_hp_bar", self, "shake_hp_bar")

func _physics_process(_delta):
	var cursor_pos = get_global_mouse_position()
	adj_pos.x = clamp(cursor_pos.x, 0, screensize.x - rect_size.x - background.rect_position.x)
	adj_pos.y = clamp(cursor_pos.y, 0 , screensize.y - rect_size.y - background.rect_position.y)
	tooltip.set_position(adj_pos)
	if is_instance_valid(PlayerStats):
		if PlayerStats.hp > 0:
			playerAlive = true
			hpLabel.set_text("Health:" + str(PlayerStats.hp) + "/" + str(PlayerStats.hp_max))
		else:
			hpLabel.set_text("RIP")
			playerAlive = false

func shake_hp_bar():
	hpBarAnimation.play("shake")
	yield(hpBarAnimation, "animation_finished")

func _on_HealthBar_mouse_entered():
	tooltip.show()
	yield(get_tree().create_timer(0.35), "timeout")


func _on_HealthBar_mouse_exited():
	tooltip.hide()
