extends CharacterBody2D

enum STATE {IDLE, GRABBED, HITSTUN}

@export var max_grab_distance: float = 10
@export var max_speed: float = 80

@export var hitstun_speed: float = 200
@export var hitstun_friction: float = 5

@onready var mouse_input: MouseInputHandler = $MouseInputHandler

var current_state = STATE.IDLE

func _ready():
	_change_to_idle()

func _process(delta):
	
	if current_state == STATE.IDLE:
		if position.distance_to(mouse_input.get_global_mouse_position()) < max_grab_distance:
					_change_to_grabbed()

func _physics_process(delta):
	
	if current_state == STATE.GRABBED:
		
		if position.distance_to(mouse_input.get_global_mouse_position()) > 1:
			velocity = (mouse_input.get_global_mouse_position() - position) * delta * max_speed
		else:
			velocity = Vector2.ZERO
	
		var collision = move_and_collide(velocity)
		
		if collision != null:
			_change_to_hitstun(collision, delta)
			print(collision.get_normal())
			
	if current_state == STATE.HITSTUN:
		
		if velocity.length() > 1:
			velocity += -velocity.normalized() * hitstun_friction * delta
			move_and_collide(velocity)
		else:
			velocity = Vector2.ZERO
			_change_to_idle()
		

func _change_to_idle():
	current_state = STATE.IDLE
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _change_to_grabbed():
	current_state = STATE.GRABBED

func _change_to_hitstun(collision: KinematicCollision2D, delta: float):
	current_state = STATE.HITSTUN
	
	velocity = collision.get_normal() * delta * hitstun_speed
	

