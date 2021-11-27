extends Control

onready var start = $HBoxContainer/MenuButtons/Start
onready var fox_sprite = $HBoxContainer/CharacterSelect/SelectionTextures/SpriteContainer/Sprite
onready var bull_sprite = $HBoxContainer/CharacterSelect/SelectionTextures/SpriteContainer/BullSprite
onready var popup_controls = $HBoxContainer/PopupMenu
onready var  menu_buttons = $HBoxContainer/MenuButtons
onready var roll_button = $HBoxContainer/PopupMenu/VBoxContainer/Roll
onready var fox_animation_player = $HBoxContainer/CharacterSelect/SelectionTextures/SpriteContainer/Sprite/AnimationPlayer
onready var controls_rich_label = $HBoxContainer/CharacterSelect/Controls_info_richlabel

func _ready(): 
	fox_sprite.frame = 0
	popup_controls.margin_top = 50
	start.grab_focus()


func _on_Start_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")


func _on_TextureButton_pressed():
	fox_sprite.visible = !fox_sprite.visible
	bull_sprite.visible = !bull_sprite.visible

func _on_Quit_pressed():
	get_tree().quit()


func _on_Controls_pressed():
	popup_controls.popup()
	roll_button.grab_focus()
	

func set_sprite_animation(sprite_animation_player, animation: String):
	sprite_animation_player.set_assigned_animation(animation)
	sprite_animation_player.play()


func _on_Run_pressed():
	set_sprite_animation(fox_animation_player, "Run")
	controls_rich_label.bbcode_text = "[center]Use [color=yellow]W,A,S,D[/color] to run![/center]"


func _on_Roll_pressed():
	set_sprite_animation(fox_animation_player, "Roll")
	controls_rich_label.bbcode_text = "[center]Use [color=yellow]Spacebar[/color] to roll![/center]"


func _on_Attack_pressed():
	set_sprite_animation(fox_animation_player, "Attack")
	controls_rich_label.bbcode_text = "[center]Use [color=yellow]F[/color] to attack![/center]"


func _on_PopupMenu_popup_hide():
	controls_rich_label.bbcode_text = ""
