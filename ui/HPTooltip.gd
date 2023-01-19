extends Popup

var screensize = Vector2(854,480)
var adj_pos = Vector2()	

onready var hpLabel = $Label
onready var background = $Label/Background
onready var playerStats = PlayerStats
onready var playerAlive = true

func _ready():
	pass

func _physics_process(_delta):
	var cursor_pos = get_global_mouse_position()
	adj_pos.x = clamp(cursor_pos.x, 0, screensize.x - rect_size.x - background.rect_position.x)
	adj_pos.y = clamp(cursor_pos.y, 0 , screensize.y - rect_size.y - background.rect_position.y)
	set_position(adj_pos)
	if playerAlive == true:
		if playerStats.hp > 0:
			hpLabel.set_text(str(playerStats.hp) + "/" + str(playerStats.hp_max))
		else:
			playerAlive = false
			hpLabel.set_text("RIP")
