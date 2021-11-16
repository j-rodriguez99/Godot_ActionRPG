extends Area2D

const Hit_effect = preload("res://Effects/HitEffect.tscn") 
onready var collision_zone = $CollisionShape2D

func _ready():
	assert(connect("area_entered", get_parent(), "damage_taken")==0)

func show_hit(): 
	var hit_effect_node = Hit_effect.instance()
	get_tree().current_scene.add_child(hit_effect_node)
	hit_effect_node.global_position = global_position


func disable_zone(time): 
	collision_zone.set_deferred("disabled", true)
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "enable_zone")
	timer.one_shot = true
	timer.set_wait_time(time)
	timer.start()
	
func enable_zone():
	collision_zone.set_deferred("disabled", false)
