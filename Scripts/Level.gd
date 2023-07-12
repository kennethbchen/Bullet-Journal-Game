extends Node2D

@export var next_scene: PackedScene

@onready var game_ui = $GameUI
@onready var results_ui = $ResultsUI

signal game_started()
signal game_ended()

func _ready():
	game_ui.show()
	results_ui.hide()
	
func start_game():
	game_started.emit()
	
func end_game():
	game_ended.emit()
	game_ui.hide()
	results_ui.show()

func _on_done_button_pressed():
	end_game()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_next_button_pressed():
	if next_scene != null:
		get_tree().change_scene_to_packed(next_scene)

func _on_reset_pen_button_pressed():
	pass
