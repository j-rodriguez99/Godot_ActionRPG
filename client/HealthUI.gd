extends Control

onready var player_stats = PlayerStats
onready var empty_hearts = $EmptyHearts
onready var full_hearts = $HeartHealth

# Called when the node enters the scene tree for the first time.
func _ready():
	player_stats.connect("health_changed", self, "update_ui")
	
func update_ui(health): 
	health = clamp(health, 0, player_stats.max_health)
	full_hearts.rect_size.x = health * 15
	

