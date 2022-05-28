extends KinematicBody2D


"""
	Node: Player
	Type: Entity
	Description: This script controls the general behavior of the `Player` node.
"""


enum SwordStates {
	IDLE = 0,
	ATTACKING = 2
}

export(int, 100, 1000, 10) var _max_movement_speed: int = 120
export(int, 1280, 3840, 10) var _movement_acceleration: int = 2560

var _velocity_vector: Vector2 = Vector2()
var _previous_movement_axis: Vector2 = Vector2()
var _current_sword_state: int = SwordStates.IDLE

onready var _PlayerSpriteStack: Sprite = $StackSorter/PlayerSpriteStack
onready var _PlayerSwordStack: Sprite = \
		$StackSorter/SwordContainer/SwordSpriteStack

	
func _physics_process(delta: float) -> void:
	_control_player_movement(delta)
	_update_stack_rotations()
	_update_stack_positions()
	

# Controls the player movement by first getting player input, and then applying
# movement or friction depending on it.
func _control_player_movement(delta: float) -> void:
	var movement_axis: Vector2 = _control_movement_feel_and_get_movement_axis()
	if movement_axis:
		_apply_movement(movement_axis * _movement_acceleration * delta)
	else:
		_apply_friction(_movement_acceleration * delta)
	move_and_slide(_velocity_vector)
	

func _update_stack_rotations() -> void:
	if _velocity_vector != Vector2():
		_PlayerSpriteStack.control_sprites_rotation(_velocity_vector.angle() - \
				deg2rad(90))
		_PlayerSwordStack.control_sprites_rotation(_velocity_vector.angle() - \
				deg2rad(90))
	
	
func _update_stack_positions() -> void:
	if _velocity_vector != Vector2() and \
			_current_sword_state == SwordStates.IDLE:
		_PlayerSwordStack.position = Vector2(-28 * sin( \
				_PlayerSwordStack.reference_sprite.rotation), \
				28 * cos(_PlayerSwordStack.reference_sprite.rotation))
			
	
# This function returns the movement axis depending on user input. It
# additionally resets the velocity vector of the player if it takes a turn so
# that the player movement is more responsive.
func _control_movement_feel_and_get_movement_axis() -> Vector2:
	var movement_axis: Vector2 = Input.get_vector("move_left", "move_right", \
			"move_forward", "move_back")
	_velocity_vector.x = 0 if sign(_previous_movement_axis.x) \
			!= sign(movement_axis.x) else _velocity_vector.x
	_velocity_vector.y = 0 if sign(_previous_movement_axis.y) \
			!= sign(movement_axis.y) else _velocity_vector.y
	_previous_movement_axis = movement_axis
	return movement_axis
	
	
func _apply_movement(acceleration_vector: Vector2) -> void:
	_velocity_vector += acceleration_vector
	_velocity_vector = _velocity_vector.clamped(_max_movement_speed)


func _apply_friction(friction_multiplier: float) -> void:
	if _velocity_vector.length() > friction_multiplier:
		_velocity_vector -= _velocity_vector.normalized() * friction_multiplier
	else:
		_velocity_vector = Vector2()


func _on_SwordAnimationPlayer_animation_started(anim_name: String) -> void:
#	match anim_name:
#		pass
	pass


func _on_SwordAnimationPlayer_animation_finished(anim_name: String) -> void:
#	match anim_name:
#		pass
	pass
