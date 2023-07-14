@tool
extends Node2D

@export var enabled: bool = false

@export_range(0, 1, 1, "or_greater") var point_count = 2

@export var init_position: Vector2
@export var init_rotation: float = 0

@export var position_offset: Vector2
@export var rotation_offset_degrees: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint() and enabled:
		
		if get_children().size() < point_count:
			
			for i in range (get_children().size(), point_count):
				var marker = Marker2D.new()
				add_child(marker)
				marker.owner = get_tree().edited_scene_root
				marker.name = str(i)
		
		if get_children().size() > point_count:
			
			for i in range (point_count, get_children().size()):
				get_child(i).queue_free()
		
		
		
		var current_position_offset = init_position
		var current_rotation_offset = init_rotation
		for child in get_children():
			
			
			child.position = current_position_offset
			child.rotation_degrees = current_rotation_offset
			
			current_position_offset += position_offset
			current_rotation_offset += rotation_offset_degrees
