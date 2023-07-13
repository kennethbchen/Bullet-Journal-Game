extends Node2D

@export var next_scene: PackedScene

@onready var controls_label: Label = $GameUI/ControlsLabel
@onready var done_label: Label = $GameUI/DoneLabel
@onready var done_button: Button = $GameUI/DoneButton

func _ready():
	controls_label.hide()
	done_label.hide()
	done_button.hide()

func _on_done_button_pressed():
	if next_scene != null:
		get_tree().change_scene_to_packed(next_scene)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_pen_grabbed():
	controls_label.show()

func _on_line_drawn():
	done_label.show()
	done_button.show()
