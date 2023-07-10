extends Node

@export var source_line_parent: Node

@export var drawing_line_parent: Node

func _ready():
	
	assert(source_line_parent is Node)
	assert(drawing_line_parent is Node)
	

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		calculate_error()

func calculate_error():
	
	var point_errors = []
	
	# For each point in the source drawing, compute the shortest distance to the player's drawing
	for source_child in source_line_parent.get_children():
		
		var source_line = source_child as Line2D
		
		
		
		for source_point in source_line.points:
			
			# Find the point in the drawing that is closest to source_point
			var closest_line = drawing_line_parent.get_child(0) as Line2D
			var closest_point = Vector2(99999,99999)
			var closest_index = 0
			
			for drawing_child in drawing_line_parent.get_children():
				
				var drawing_line = drawing_child as Line2D
				
				for i in range(drawing_line.points.size()):
					if source_point.distance_squared_to(drawing_line.points[i]) < source_point.distance_squared_to(closest_point):
						closest_line = drawing_line
						closest_point = drawing_line.points[i]
						closest_index = i

			# Find the shortest distance between source_point and the
			# segments that contain the closest point
			
			var shortest_distance = 999999999
			
			if closest_index > 0:
				shortest_distance = min(shortest_distance, source_point.distance_to(Geometry2D.get_closest_point_to_segment(source_point, closest_line.points[closest_index - 1], closest_line.points[closest_index])))
				
			if closest_index < closest_line.points.size() - 1:
				shortest_distance = min(shortest_distance, source_point.distance_to(Geometry2D.get_closest_point_to_segment(source_point, closest_line.points[closest_index], closest_line.points[closest_index + 1])))
			
			point_errors.push_back(shortest_distance)
	
	# Compute the standard deviation of the distance error
	
	var avg_error: float = 0.0
	
	for num in point_errors:
		avg_error += num
	
	avg_error /= point_errors.size()
	
	print(avg_error)
	
	return avg_error
