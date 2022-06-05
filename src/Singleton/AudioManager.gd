extends Node


"""
	Node: AudioManager
	Type: Singleton
	Description: This script controls the audio of the game.
"""


onready var _SFXASPS: Node = $SFXASPS


func play_sound_effect(sfx_path: String, with_db: float) -> void:
	var sfx_stream: AudioStreamSample = load(sfx_path)
	var temp_asp: AudioStreamPlayer = AudioStreamPlayer.new()
	_SFXASPS.add_child(temp_asp)
	temp_asp.stream = sfx_stream
	temp_asp.volume_db = with_db
	temp_asp.pause_mode = PAUSE_MODE_PROCESS
	temp_asp.play()
	yield(temp_asp, "finished")
	temp_asp.queue_free()
