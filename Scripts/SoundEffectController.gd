extends Node

class_name SoundEffectController

@export_range(0, 1, 1, "or_greater") var num_players: int = 1

@export var audio_bus = "Master"

@export var sound_effects: Array[SoundEffect]

var audio_players: Array[AudioStreamPlayer] = []

# Map from sound effect name to its index in sound_effects array
var effect_map: Dictionary

# Map from sound effect name to the index of the sound effect that was last played from it
var last_played_map: Dictionary

var rand: RandomNumberGenerator

signal players_finished()

func _ready():
	
	rand = RandomNumberGenerator.new()
	rand.randomize()
	
	# Populate effect_map and last_played_map
	for i in range(0, sound_effects.size()):
		
		var effect = sound_effects[i]
		
		effect_map[effect.name] = effect_map.size()
		last_played_map[effect.name] = -1
		
	# Create AudioStreamPlayers
	for _i in range(0, num_players):
		var player = AudioStreamPlayer.new()
		player.bus = audio_bus
		player.finished.connect(_on_player_done)
		audio_players.append(player)
		
		add_child(player)

func _has_effect(effect_name: String):
	return effect_map.has(effect_name)

func _get_effect(effect_name: String):
	return sound_effects[effect_map[effect_name]]


func _try_play_sound(audio: AudioStream):
	
	for player in audio_players:
		if not player.playing:
			player.stream = audio
			player.play()
			return

func play(name: String) -> void:
	
	if not _has_effect(name):
		push_warning("SoundEffectController has no effect named ", name)
		return
	
	var clips = _get_effect(name).audio_clips
	
	if clips.size() == 1:
		
		# Only one sound effect to play anyways
		_try_play_sound(clips[0])
		return
		
	
	var index = rand.randi_range(0, clips.size() - 1)
	
	# Avoid playing the same clip twice
	if index == last_played_map[name]:
		index = (index + 1) % clips.size()
	
	last_played_map[name] = index
	
	_try_play_sound(clips[index])

func play_one_shot(sound):
	_try_play_sound(sound)

func is_playing() -> bool:
	for player in audio_players:
		if player.playing:
			return true
	
	return false

func _on_player_done() -> void:
	
	for player in audio_players:
		if player.playing:
			return
	
	players_finished.emit()

func _on_sound_requested(name: String):
	play(name)
