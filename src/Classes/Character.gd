class_name Character
extends KinematicBody2D


"""
	Node: -
	Type: Class
	Description: This script is the base class for the playable characters
	and the enemy characters.
"""


export(Resource) var _sfx_data: Resource = null


func _initialize_signal_connections() -> void:
	pass
	

func _request_to_play_sound_effect(effect_identifier: String) -> void:
	AudioManager.play_sound_effect(_sfx_data.get("%s_sfx_path" \
			% effect_identifier), _sfx_data.get("%s_sfx_db" \
			% effect_identifier))
