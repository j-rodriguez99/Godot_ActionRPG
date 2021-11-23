extends Control

onready var start = $HBoxContainer/MenuButtons/Start
onready var fox_sprite = $HBoxContainer/CharacterSelect/SelectionTextures/SpriteContainer/Sprite

func _ready(): 
	start.grab_focus()

func _on_Start_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")


func _on_TextureButton_pressed():
	fox_sprite.visible = !fox_sprite.visible


func _on_Quit_pressed():
	get_tree().quit()
