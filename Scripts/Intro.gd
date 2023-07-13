extends Node2D

@export var next_scene: PackedScene

@onready var results_ui: CanvasLayer = $ResultsUI
@onready var main_ui: CanvasLayer = $GameUI
@onready var credits_ui: CanvasLayer = $CreditsUI

@onready var controls_label: Label = $GameUI/ControlsLabel
@onready var done_label: Label = $GameUI/DoneLabel
@onready var done_button: Button = $GameUI/DoneButton

signal game_ended()

func _ready():
	results_ui.hide()
	main_ui.show()
	credits_ui.hide()
	
	controls_label.hide()
	done_label.hide()
	done_button.hide()

func _on_next_button_pressed():
	if next_scene != null:
		get_tree().change_scene_to_packed(next_scene)
		
func _on_done_button_pressed():
	results_ui.show()
	main_ui.hide()
	credits_ui.hide()
	
	game_ended.emit()

func _on_credits_button_pressed():
	credits_ui.show()
	main_ui.hide()

func _on_close_credits_button_pressed():
	credits_ui.hide()
	main_ui.show()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_pen_grabbed():
	controls_label.show()

func _on_line_drawn():
	done_label.show()
	done_button.show()
