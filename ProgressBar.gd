extends ProgressBar


onready var roll_timmer : Timer = get_node("../RollTimer")

func _ready():
	value = 3 - roll_timmer.get_time_left()
