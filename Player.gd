extends KinematicBody2D

var max_speed : float = 80.0
const Acceleration : int = 500
const Friction : int = 500
const Roll_Speed : int = 120

var velocity : Vector2 = Vector2.ZERO
var roll_direction : Vector2 = Vector2.DOWN

onready var progress_bar = $ProgressBar
onready var animation_tree : AnimationTree = $AnimationTree
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var animation_player_two = $AnimationPlayer2
onready var animation_state : Object = animation_tree.get("parameters/playback")
onready var sword_hitbox : Area2D = $Position2DHitboxPivot/SwordHitbox
onready var hurtbox = $PlayerHurtbox
onready var hurtbox_zone = $PlayerHurtbox/CollisionShape2D
onready var roll_timer : Timer = $RollTimer
var stats = PlayerStats

enum {
	Move, 
	Attack, 
	Roll
}

var roll_energy : bool = true
var state : int = Move

func _ready() -> void:
	print(global_position)
	animation_tree.active = true
	stats.connect("death", self, "game_over")


func _physics_process(delta : float) -> void:
	global_position.x = clamp(global_position.x, 0, 1400)
	global_position.y = clamp(global_position.y, 0, 1400)
	
	progress_bar.value = 3 - roll_timer.get_time_left()
	progress_bar.visible = !roll_energy
	
	match state: 
		Move: 
			move_state(delta)
		Attack: 
			attack_state()
		Roll: 
			roll_state(roll_direction)


func move_state(delta: float) -> void: 
	var input_vector: Vector2 = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up") 
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		
		roll_direction = input_vector
		sword_hitbox.knockback_vector = input_vector
		
		velocity = velocity.move_toward(input_vector * max_speed, Acceleration * delta)
	else:
		animation_state.travel("Idle") 
		velocity = velocity.move_toward(Vector2.ZERO, delta * Friction)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_pressed("Attack"):
		state = Attack
	
	if Input.is_action_pressed("ui_accept") and roll_energy: 
		state = Roll
		roll_energy = false
		roll_timer.start()


func attack_state() -> void:
	velocity = Vector2.ZERO
	animation_state.travel("Attack")


func roll_state(direction) -> void:
	animation_state.travel("Roll") 
	velocity = move_and_slide(direction * Roll_Speed)


func _reset() -> void: 
	state = Move


func _on_RollTimer_timeout():
	roll_energy = true


func damage_taken(_area):
	hurtbox.show_hit()
	stats.health -= 1
	animation_player_two.play("DamageTaken")
	hurtbox.hurtbox_disable_zone() 


func game_over():
	queue_free()
