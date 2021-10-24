extends KinematicBody2D

var knockback : Vector2 = Vector2.ZERO
onready var stats : Node = $Stats

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, delta * 100)
	knockback = move_and_slide(knockback)
	


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	knockback = area.knockback_vector * 100
	
	stats.health -= area.damage


func _on_Stats_death() -> void:
	queue_free()
