extends Character


"""
	Node: Enemy
	Type: Entity
	Description: This script controls the general behavior of the `Enemy` node.
"""


onready var _Player: KinematicBody2D = \
		get_tree().get_nodes_in_group("Player")[-1]


func _ready() -> void:
	_initialize_data_resources()
	_initialize_signal_connections()
	

func _physics_process(delta: float) -> void:
	_control_character_movement(delta)
	_update_stack_rotations(delta)
	_control_knowckback_wobble()


func _initialize_signal_connections() -> void:
	_Tween.connect("tween_completed", self, "on_Tween_completed")
	_InvulTimer.connect("timeout", health_data, "_on_InvulTimer_timeout")
	
	
func _control_character_movement(delta: float) -> void:
	var movement_axis: Vector2 = (_Player.position - position).normalized()
	_apply_movement(movement_axis * \
			_combat_stats_data.movement_acceleration * delta)
	move_and_slide(_velocity_vector + _temp_additional_velocity_vector)
	
	
func _update_stack_rotations(_delta: float) -> void:
	_CharacterSpriteStack.control_children_rotation( \
					_velocity_vector.angle() - deg2rad(90))


func die() -> void:
	_Collision.set_deferred("disabled", true)
	_CharacterSpriteStack.fade_out_sprites()
	
