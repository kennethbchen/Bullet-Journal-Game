extends Resource

class_name SoundEffect

@export var name: String

@export var audio_clips: Array[AudioStream]

func _ready():
	assert(not name.is_empty())
	assert(not audio_clips.is_empty())
