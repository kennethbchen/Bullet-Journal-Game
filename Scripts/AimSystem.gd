extends Node2D

@export var enabled: bool = true

@export var aim_target: Node2D

@export var aim_speed: float = 10.0

var target_rotation_radians: float = 0

func init(target: Node2D):
	aim_target = target

func _process(delta):
	if enabled and aim_target != null:
		target_rotation_radians = get_angle_to(aim_target.global_position)
		rotation = lerp_angle(rotation, rotation + target_rotation_radians, aim_speed * delta) 

func angle_error():
	return abs(_angle_dif(rotation, rotation + target_rotation_radians))

# Returns angle in radians ranging from -PI to PI 
func _angle_dif(from : float, to : float):
	var ans = fposmod(to - from, TAU)
	
	if ans > PI:
		ans -= TAU
	return ans
	
