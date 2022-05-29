class_name Character
extends KinematicBody2D


"""
	Node: -
	Type: Class
	Description: This script is the base class for the playable characters
	and the enemy characters.
"""


enum MovementStates {
	NORMAL = 0,
	KNOCKBACKED = 2
}

export(Resource) var health_data: Resource = null
export(Resource) var _combat_stats_data: Resource = null
export(Resource) var _animation_data: Resource = null
export(Resource) var _sfx_data: Resource = null

var _current_movement_state: int = MovementStates.NORMAL
var _velocity_vector: Vector2 = Vector2()
var _temp_additional_velocity_vector: Vector2 = Vector2()

onready var _CharacterSpriteStack: Sprite = $Stacks/CharacterSpriteStack
onready var _Collision: CollisionShape2D = $Collision
onready var _Tween: Tween = $Tween
onready var _InvulTimer: Timer = $InvulTimer


func _initialize_signal_connections() -> void:
	pass
	

func _initialize_data_resources() -> void:
	health_data.reset(self, _InvulTimer)
	
	
func _control_character_movement(_delta: float) -> void:
	pass
	
	
func _apply_movement(acceleration_vector: Vector2) -> void:
	if health_data.is_alive:
		_velocity_vector += acceleration_vector
		_velocity_vector = _velocity_vector.clamped( \
				_combat_stats_data.max_movement_speed)
		return
	_velocity_vector = Vector2()
			
			
func _update_stack_rotations(_delta: float) -> void:
	pass
	

func _control_knowckback_wobble() -> void:
	if _current_movement_state == MovementStates.KNOCKBACKED:
		_CharacterSpriteStack.scale.y = range_lerp( \
				_temp_additional_velocity_vector.length(), \
				0, _combat_stats_data.MAX_WOBBLE_KNOCKBACK_VECTOR_LENGTH, \
				1.5, 1.25)
		_CharacterSpriteStack.scale.x = range_lerp( \
				_temp_additional_velocity_vector.length(), \
				0, _combat_stats_data.MAX_WOBBLE_KNOCKBACK_VECTOR_LENGTH, \
				1.5, 2)


func apply_knockback_effect(attacker: Object, power: int = 100, \
		duration: float = 0.4) -> void:
	_current_movement_state = MovementStates.KNOCKBACKED
	_temp_additional_velocity_vector = \
			(position - attacker.position).normalized() * power
	_Tween.remove(self, "_temp_additional_velocity_vector")
	_Tween.interpolate_property(self, "_temp_additional_velocity_vector", \
				_temp_additional_velocity_vector, Vector2(), duration, \
				Tween.TRANS_QUAD, Tween.EASE_OUT)
	_Tween.start()
	
	
func _request_to_play_sound_effect(effect_identifier: String) -> void:
	AudioManager.play_sound_effect(_sfx_data.get("%s_sfx_path" \
			% effect_identifier), _sfx_data.get("%s_sfx_db" \
			% effect_identifier))


func _spawn_character() -> void:
	_CharacterSpriteStack.drop_in_sprites()


func die() -> void:
	pass
	
	
func on_Tween_completed(object: Object, key: NodePath) -> void:
	match key:
		NodePath(":_temp_additional_velocity_vector"):
			_current_movement_state = MovementStates.NORMAL


func _on_CharacterSpriteStack_StackTween_completed(object: Object, \
		key: NodePath) -> void:
	if object == _CharacterSpriteStack.top_sprite and \
			key == ":offset":
		_Collision.disabled = false
		health_data.is_alive = true
