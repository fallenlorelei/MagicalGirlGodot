extends Node2D

var scene

onready var attack_origin = $AttackOrigin

func _ready():
  scene = preload("res://Attacks//ShootAttack.tscn")


func _process(_delta):

	if Input.is_action_just_pressed("ability1") or Input.is_action_just_pressed("left_click"):
		if get_parent().state != get_parent().JUMP:
			var instance = scene.instance()
			instance.position = attack_origin.position
			add_child(instance)
