extends Character


"""
	Node: Player
	Type: Entity
	Description: This script controls the general behavior of the `Player` node.
"""


enum SwordStates {
	IDLE = 0,
	PREPARING_TO_ATTACK = 1,
	ATTACKING = 2
}

var _previous_movement_axis: Vector2 = Vector2()
var _current_sword_state: int = SwordStates.IDLE setget \
		_set_current_sword_state

onready var _PlayerSwordStack: Sprite = \
		$Stacks/SwordContainer/SwordSpriteStack
onready var _SwordSpriteStack: Sprite = $Stacks/SwordContainer/SwordSpriteStack
onready var _SwordAnimationPlayer: AnimationPlayer = $SwordAnimationPlayer


func _ready() -> void:
	_initialize_data_resources()
	_initialize_signal_connections()
	_spawn_character()
	_PlayerSwordStack.position = Vector2(0, 28) # remove
	
	
func _physics_process(delta: float) -> void:
	_control_character_movement(delta)
	_update_stack_rotations(delta)
	_update_stack_positions()
	
	
func _initialize_signal_connections() -> void:
	BeatManager.connect("beat_dropped", self, "_on_beat_dropped")
	_CharacterSpriteStack.StackTween.connect("tween_completed", self, \
			"_on_CharacterSpriteStack_StackTween_completed")
	_InvulTimer.connect("timeout", health_data, "_on_InvulTimer_timeout")


# Controls the player movement by first getting player input, and then applying
# movement or friction depending on it.
func _control_character_movement(delta: float) -> void:
	var movement_axis: Vector2 = _control_movement_feel_and_get_movement_axis()
	if movement_axis:
		_apply_movement(movement_axis * \
				_combat_stats_data.movement_acceleration * delta)
	else:
		_apply_friction(_combat_stats_data.movement_acceleration * delta)
	move_and_slide(_velocity_vector)
	

func _update_stack_rotations(delta: float) -> void:
	if _current_sword_state == SwordStates.IDLE and \
			health_data.is_alive:
		if _velocity_vector != Vector2():
			_CharacterSpriteStack.control_children_rotation( \
					_velocity_vector.angle() - deg2rad(90))
		_PlayerSwordStack.control_children_rotation( \
				_PlayerSwordStack.reference_sprite.rotation - \
				deg2rad(delta * \
						_combat_stats_data.weapon_stack_rotation_speed))
	
	
func _update_stack_positions() -> void:
	if _current_sword_state == SwordStates.IDLE and \
			health_data.is_alive:
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


func _apply_friction(friction_multiplier: float) -> void:
	if _velocity_vector.length() > friction_multiplier:
		_velocity_vector -= _velocity_vector.normalized() * friction_multiplier
	else:
		_velocity_vector = Vector2()


func _spawn_character() -> void:
	_CharacterSpriteStack.drop_in_sprites()
	_SwordSpriteStack.drop_in_sprites()
	
	
func _set_current_sword_state(state: int) -> void:
	_current_sword_state = state
	
	
func _on_SwordAnimationPlayer_animation_started(anim_name: String) -> void:
	_SwordAnimationPlayer.playback_speed = _animation_data. \
			get("%s_as" % anim_name)
	match anim_name:
		"idle":
			_current_sword_state = SwordStates.IDLE
		"whirlwind":
			_current_sword_state = SwordStates.PREPARING_TO_ATTACK


func _on_SwordAnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"idle":
			_SwordAnimationPlayer.play("idle")
		"whirlwind":
			_SwordAnimationPlayer.play("idle")


# Checks the attack queue and executes the next attack by playing its
# animation.
func _on_beat_dropped() -> void:
	if health_data.is_alive:
		_SwordAnimationPlayer.play("whirlwind")


func _on_SwordArea_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		if _current_sword_state == SwordStates.ATTACKING and \
				body.health_data.can_get_hit:
			_request_to_play_sound_effect("hit")
			body.health_data.can_get_hit = false
			body.health_data.take_damage(_combat_stats_data.attack_damage)
			body.apply_knockback_effect(self, \
					_combat_stats_data.knockback_power, \
					_combat_stats_data.knockback_duration)


func _on_CharacterSpriteStack_StackTween_completed(object: Object, \
		key: NodePath) -> void:
	if object == _CharacterSpriteStack.top_sprite and \
			key == ":offset":
		_Collision.disabled = false
		health_data.is_alive = true
#		_SwordSpriteStack.visible = true
#		_SwordSpriteStack.fade_in_out_sprites(false)
