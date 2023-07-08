extends CharacterBody2D

enum STATE {IDLE, GRABBED, HITSTUN}

@export var max_grab_distance: float = 10

var current_state = STATE.IDLE


func _ready():
	_change_to_idle()
	
	pass # Replace with function body.

func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		
			if current_state == STATE.IDLE:
		
				if position.distance_to(get_global_mouse_position()) < max_grab_distance:
					_change_to_grabbed()

			if current_state == STATE.GRABBED:
				position = get_global_mouse_position()



func _change_to_grabbed():
	current_state = STATE.GRABBED

func _change_to_idle():
	current_state = STATE.IDLE
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
