class_name Character
extends KinematicBody2D


"""
	Node: -
	Type: Class
	Description: This script is the base class for the playable characters
	and the enemy characters.
"""


export(Resource) var _combat_stats_data: Resource = null
export(Resource) var _animation_data: Resource = null
export(Resource) var _sfx_data: Resource = null

var _velocity_vector: Vector2 = Vector2()

onready var _CharacterSpriteStack: Sprite = $Stacks/CharacterSpriteStack


func _initialize_signal_connections() -> void:
	pass
	

func _control_character_movement(delta: float) -> void:
	pass
	
	
func _apply_movement(acceleration_vector: Vector2) -> void:
	_velocity_vector += acceleration_vector
	_velocity_vector = _velocity_vector.clamped( \
			_combat_stats_data.max_movement_speed)
			
			
func _update_stack_rotations(delta: float) -> void:
	pass
	
	
func _request_to_play_sound_effect(effect_identifier: String) -> void:
	AudioManager.play_sound_effect(_sfx_data.get("%s_sfx_path" \
			% effect_identifier), _sfx_data.get("%s_sfx_db" \
			% effect_identifier))
