extends Node2D

enum STATE {NOT_STARTED, STARTED, ENDED}
@export var next_scene: PackedScene

@onready var game_ui = $GameUI
@onready var results_ui = $ResultsUI

var current_state = STATE.NOT_STARTED

signal game_started()
signal game_ended()

func _ready():
	game_ui.show()
	results_ui.hide()
	
func start_game():
	game_started.emit()
	current_state = STATE.STARTED
	
func end_game():
	game_ended.emit()
	game_ui.hide()
	results_ui.show()
	current_state = STATE.ENDED

func _on_done_button_pressed():
	
	if current_state != STATE.ENDED:
		end_game()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_next_button_pressed():
	if next_scene != null:
		get_tree().change_scene_to_packed(next_scene)

func _on_pen_grabbed():
	
	if current_state == STATE.NOT_STARTED:
		start_game()
