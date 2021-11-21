extends Control

onready var start = $HBoxContainer/VBoxContainer/Start

func _ready(): 
	start.grab_focus()

func _on_Start_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")


func _on_TextureButton_pressed():
	print("left or right button pressed")
