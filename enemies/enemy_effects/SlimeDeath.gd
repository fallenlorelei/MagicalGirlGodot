extends AnimatedSprite


func _ready():
	play("green_death")

func _on_SlimeDeath_animation_finished():
	queue_free()
