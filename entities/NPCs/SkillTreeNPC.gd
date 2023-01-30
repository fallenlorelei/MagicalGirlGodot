extends StaticBody2D

onready var skillTree = preload("res://ui/skill_trees/SkillTree.tscn")
onready var sprite = $Sprite

var interactable = false
var mouseOverNPC = false

func _physics_process(delta):
	if mouseOverNPC == true && Input.is_action_just_pressed("left_click"):
		open_skilltree()
	
func _ready():
	pass

func _on_Mouseover_mouse_entered():
	sprite.material.set_shader_param("line_color", Color(0.945098, 1, 0.74902))
	SignalBus.emit_signal("mouseover", true)
	if interactable == true:
		mouseOverNPC = true

func _on_Mouseover_mouse_exited():
	sprite.material.set_shader_param("line_color", Color(0.945098, 1, 0.74902, 0))
	SignalBus.emit_signal("mouseover", false)
	mouseOverNPC = false

func _on_InteractionZone_body_entered(body):
	if body.is_in_group("Player"):
		interactable = true

func _on_InteractionZone_body_exited(body):
	if body.is_in_group("Player"):
		interactable = false

func open_skilltree():
	var skillTreeInstance = skillTree.instance()
	skillTreeInstance.rect_scale = Vector2(0,0)
	get_tree().get_root().get_node("Tilemap World/CanvasLayer").add_child(skillTreeInstance)
	
	var crystalCounter = get_tree().get_root().get_node("Tilemap World/CanvasLayer/CrystalCounter")
	
	var TW = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	TW.tween_property(crystalCounter, "rect_position:x", -5.0, .3)
	TW.parallel().tween_property(skillTreeInstance, "rect_scale", Vector2(1,1), .3)
	TW.tween_callback(self, "pause")
	
func pause():
	get_tree().paused = true
