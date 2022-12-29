extends Area2D

var velocity = Vector2()

# Things we want to be able to change
var speed = 300

func _ready():
  velocity = get_global_mouse_position() - global_position
	#pass # Replace with function body.

func _physics_process(delta):
  # Shoot bullet in direction of mouse
  velocity = velocity.normalized() * speed
  position += velocity * delta



  

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass