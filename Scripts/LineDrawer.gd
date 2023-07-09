extends Line2D

class_name LineDrawer

@export var enabled: bool = false

@export var tracked_node: Node2D

@export var min_distance: float =  6




var tracked_position: Vector2:
	get:
		return tracked_node.position

var first_point: Vector2:
	get:
		return points[0]

var last_point: Vector2:
	get:
		return points[points.size() - 1]
		
signal loop_created(line_drawer, points)

func init(node_to_track: Node2D):
	tracked_node = node_to_track
	enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if tracked_node == null or not enabled:
		return
	
	if points.size() == 0:
		_append_point()
	
	# Try to add new points to the line
	if last_point.distance_to(tracked_position) > min_distance:
		
		_append_point()
		


func _append_point():
	add_point(tracked_position, points.size() + 1)
