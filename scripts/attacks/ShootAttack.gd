extends Area2D

var velocity = Vector2()

# Things we want to be able to change
export var damage = 1
export var speed = 300

func _ready():
  velocity = get_global_mouse_position() - global_position

func _physics_process(delta):
  # Shoot bullet in direction of mouse
  velocity = velocity.normalized() * speed
  position += velocity * delta

# Is destroyed when it hits something (only hits enemies right now but should eventually hit buildings)
func _on_Hitbox_area_entered(area):
	queue_free()
