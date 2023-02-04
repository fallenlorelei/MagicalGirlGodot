extends TextureProgress

onready var tooltip = $ExpTooltip
onready var expLabel = $ExpTooltip/Label
onready var background = $ExpTooltip/Label/Background
#onready var playerStats = PlayerStats


var screensize = OS.window_size
var adj_pos = Vector2()	


func _ready():
	pass
	
func _on_ExpBar_mouse_entered():
	tooltip.show()
	yield(get_tree().create_timer(0.35), "timeout")

func _on_ExpBar_mouse_exited():
	tooltip.hide()

func _physics_process(_delta):
	var cursor_pos = get_global_mouse_position()
	adj_pos.x = clamp(cursor_pos.x, 0, screensize.x - rect_size.x - background.rect_position.x)
	adj_pos.y = clamp(cursor_pos.y, 0 , screensize.y - rect_size.y - background.rect_position.y)
	tooltip.set_position(adj_pos)
#	if is_instance_valid(playerStats):
#		if playerStats.hp > 0:
#			expLabel.set_text("Experience: 100/400")
