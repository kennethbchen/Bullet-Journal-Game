extends CharacterBody2D

enum STATE {DISABLED, IDLE, GRABBED, HITSTUN}

@export_group("Nodes")
@export var line_drawer_scene: PackedScene
@export var line_parent: Node

@export_group("Movement")
@export var max_grab_distance: float = 10
@export var max_speed: float = 80
@export var grab_bounds: Rect2


@export_group("Hitstun")
@export var hitstun_speed: float = 200
@export var hitstun_friction: float = 5

@onready var pen_sprite: Sprite2D = $PenSprite
@onready var mouse_input: MouseInputHandler = $MouseInputHandler

var current_state: STATE = STATE.IDLE

var current_line_drawer: LineDrawer

signal pen_grabbed()

func _ready():
	
	assert(line_drawer_scene != null)
	assert(line_parent != null)
	
	_change_to_idle()

func _process(delta):
	
	if current_state == STATE.IDLE:
		if position.distance_to(mouse_input.get_global_mouse_position()) < max_grab_distance:
					_change_to_grabbed()

func _physics_process(delta):
	
	if current_state == STATE.GRABBED:
		
		if position.distance_to(mouse_input.get_global_mouse_position()) > 0.1:
			velocity = (mouse_input.get_global_mouse_position() - position) * delta * max_speed
		else:
			velocity = Vector2.ZERO
	
		var collision = move_and_collide(velocity)
		
		if collision != null:
			
			if collision.get_collider().get_groups().has("Wall"):
				_change_to_idle()
			else:
				_change_to_hitstun(collision, delta)
			
	if current_state == STATE.HITSTUN:
		
		if velocity.length() > 1:
			velocity += -velocity.normalized() * hitstun_friction * delta
			move_and_collide(velocity)
		else:
			velocity = Vector2.ZERO
			
			_stop_drawing()
			_change_to_idle()

func _change_to_disabled():
	_change_to_idle()
	current_state = STATE.DISABLED

func _change_to_idle():
	current_state = STATE.IDLE
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	pen_sprite.modulate = Color(1,1,1,1)
	
	_stop_drawing()
	

func _change_to_grabbed():
	current_state = STATE.GRABBED
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	pen_sprite.modulate = Color(1,1,1,0.5)
	
	pen_grabbed.emit()

func _change_to_hitstun(collision: KinematicCollision2D, delta: float):
	current_state = STATE.HITSTUN
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	pen_sprite.modulate = Color(1,1,1,0.5)
	
	_start_drawing()
	
	velocity = collision.get_normal() * delta * hitstun_speed
	
func _start_drawing():
	
	pen_sprite.position = Vector2.ZERO
	
	if current_line_drawer != null:
		return
	
	var new_line = line_drawer_scene.instantiate() as LineDrawer
	add_child(new_line)
	new_line.init(self)
	current_line_drawer = new_line
	
func _stop_drawing():
	
	pen_sprite.position = Vector2(1, -6)
	
	if current_line_drawer == null:
		return
	
	# Don't add pointless (ha) lines to the line parent
	if current_line_drawer.points.size() <= 1:
		current_line_drawer.queue_free()
		return
	
	
	
	current_line_drawer.enabled = false
	current_line_drawer.set_script(null)
	current_line_drawer.reparent(line_parent)
	current_line_drawer = null
	
func _on_left_mouse_pressed():
	if current_state == STATE.GRABBED:
		_start_drawing()
		
func _on_left_mouse_released():
	if current_state == STATE.GRABBED:
		_stop_drawing()

func _on_game_ended():
	_change_to_disabled()
