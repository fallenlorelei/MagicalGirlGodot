extends Node2D

onready var camera = $Camera2D
onready var cameraLimitShape = $CameraLimit

func _ready():
	randomize()

	camera.limit_left   = cameraLimitShape.rect_position.x
	camera.limit_right  = cameraLimitShape.rect_position.x + cameraLimitShape.rect_size.x
	camera.limit_top    = cameraLimitShape.rect_position.y
	camera.limit_bottom = cameraLimitShape.rect_position.y + cameraLimitShape.rect_size.y
