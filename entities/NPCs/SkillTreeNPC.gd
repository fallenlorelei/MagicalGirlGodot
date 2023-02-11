extends StaticBody2D

onready var skillTree = preload("res://ui/skill_trees/SkillTree.tscn")
onready var sprite = $AnimatedSprite

export(String, "Light", "Dark", "Psychic", "Fire", "Ice", "Earth", "Thunder", "Wind", "Water") var treeElement

var interactable = false
var mouseOverNPC = false

func _physics_process(delta):
	if mouseOverNPC == true && Input.is_action_just_pressed("left_click"):
		open_skilltree()
	
func _ready():
	var nums = [-1,1]
	sprite.scale.x = nums[randi() % nums.size()]
	match treeElement:
		"Light":
			sprite.play("light_sit")
		"Dark":
			sprite.play("dark_sit")
		"Psychic":
			sprite.play("psychic_sit")
		"Fire":
			sprite.play("fire_sit")
		"Water":
			sprite.play("water_sit")
		"Ice":
			sprite.play("ice_sit")
		"Thunder":
			sprite.play("thunder_sit")
		"Wind":
			sprite.play("wind_sit")
		"Earth":
			sprite.play("earth_sit")

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
	skillTreeInstance.treeElement = treeElement
	
	var crystalCounter = get_tree().get_root().get_node("Station/CanvasLayer/CrystalCounter")
	
	get_tree().get_root().get_node("Station/CanvasLayer").add_child(skillTreeInstance)
	get_tree().get_root().get_node("Station/CanvasLayer").move_child(skillTreeInstance,1)
		
	var TW = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	TW.tween_property(crystalCounter, "rect_position:x", crystalCounter.posOpenx, .3)
	TW.parallel().tween_property(skillTreeInstance, "rect_scale", Vector2(1,1), .3)
	TW.tween_callback(self, "pause")
	
func pause():
	get_tree().paused = true
