extends Node2D

class_name MouseInputHandler

var global_mouse_position

signal left_mouse_pressed()
signal left_mouse_released()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			left_mouse_pressed.emit()
			
		if event.is_released():
			left_mouse_released.emit()
	
	if event is InputEventMouseMotion:
		global_mouse_position = get_global_mouse_position()

