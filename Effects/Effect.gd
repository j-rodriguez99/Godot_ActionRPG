extends AnimatedSprite

func _ready() -> void:
	play("Animate")
	connect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished() -> void:
	queue_free()
	
