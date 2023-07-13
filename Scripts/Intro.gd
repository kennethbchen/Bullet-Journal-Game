extends Node2D

@export var next_scene: PackedScene

func _on_done_button_pressed():
	if next_scene != null:
		get_tree().change_scene_to_packed(next_scene)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
