extends Node2D

@export var next_scene: PackedScene

@onready var credits_parent: Control = $UI/Credits

func _ready():
	credits_parent.hide()

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(next_scene)

func _on_credits_button_pressed():
	credits_parent.show()
	
func _on_close_credits_pressed():
	credits_parent.hide()
