extends Node

@export var run_forever = false

@export var projectile_parent: Node

@export var steps: Array[ProjectileGeneratorStep]

var running : bool = false

var should_stop = false

signal sound_requested(name: String)

func _ready():
	pass

func _process(delta):
	
	if run_forever and not running:
		start()

func stop():
	should_stop = true
	run_forever = false
	
func start():
	
	if running: return
	
	running = true
	for step in steps:
		
		if step.skip:
			continue
		
		var spawn_pos_parent = get_node(step.spawn_position_parent_path)
		
		var rotation_inherit_source: Node2D = get_node_or_null(step.aim_rotation_source_path)
		
		for step_cycle in range(0, step.step_cycles):
			
			# Inherit rotation if needed
			if rotation_inherit_source != null and \
						step.aim_type == step.AIM_TYPE.PER_STEP:
				spawn_pos_parent.rotation_degrees = rotation_inherit_source.rotation_degrees
			
			# Play Sound Effect if needed
			if not step.sound_effect_name.is_empty() and step.sound_type == step.SFX_TYPE.PER_STEP:
				sound_requested.emit(step.sound_effect_name)
			
			for spawn_cycle in range(0, step.spawn_cycles):
				
				
				if should_stop:
					should_stop = false
					return
				
				# Inherit rotation if needed
				if rotation_inherit_source != null and \
						step.aim_type == step.AIM_TYPE.PER_SPAWN:
					spawn_pos_parent.rotation_degrees = rotation_inherit_source.rotation_degrees
				
				# Play Sound Effect if needed
				if not step.sound_effect_name.is_empty() and step.sound_type == step.SFX_TYPE.PER_SPAWN:
					sound_requested.emit(step.sound_effect_name)
				
				for spawn_point in spawn_pos_parent.get_children():

					var new_projectile = step.projectile_scene.instantiate()
					projectile_parent.add_child(new_projectile)
					new_projectile.global_position = spawn_point.global_position
					new_projectile.rotation = spawn_point.global_rotation
				
				await get_tree().create_timer(step.spawn_delay).timeout
			
			# Apply transform offsets
			spawn_pos_parent.position += step.position_offset
			spawn_pos_parent.rotation_degrees += step.rotation_offset_degrees
			
			await get_tree().create_timer(step.transition_delay).timeout
	
	running = false
	
func _on_game_ended():
	stop()
