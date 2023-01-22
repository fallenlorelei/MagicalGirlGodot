extends Control

export (NodePath) var player
export var zoom = 1.5

onready var mapBg = $HBoxContainer/MinimapFrame/MapBG
onready var playerMarker = $HBoxContainer/MinimapFrame/MapBG/PlayerMarker
onready var enemyMarker = $HBoxContainer/MinimapFrame/MapBG/EnemyMarker
onready var alertMarker = $HBoxContainer/MinimapFrame/MapBG/AlertMarker

onready var icons = {"enemy": enemyMarker, "alert": alertMarker}

var bgScale
var markers = {}

func _ready():
	playerMarker.position = mapBg.rect_size / 2
	bgScale = mapBg.rect_size / (get_viewport_rect().size * zoom)
	
func _process(_delta):
	if !player:
		return
	
