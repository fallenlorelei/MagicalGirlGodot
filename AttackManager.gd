extends Node2D

var scene

func _ready():
  scene = preload("res://Attacks//ShootAttack.tscn")
	#pass # Replace with function body.

func _process(_delta):
  # Input should call a function in attack manager from player script, not done here
  if Input.is_action_just_pressed("ability1") or Input.is_action_just_pressed("left_click"):
    var instance = scene.instance()
    instance.position.x = position.x + 15
    instance.position.y = position.y - 15
    add_child(instance)
    