extends KinematicBody2D


"""
	Node: Player
	Type: Entity
	Description: This script controls the general behavior of the `Player` node.
"""


export(int, 100, 1000, 10) var _movement_speed: int = 380
export(int, 10, 100, 1) var _movement_speed_multiplier: int = 52


func _physics_process(delta: float) -> void:
	_control_player_movement(delta)
	
	
func _control_player_movement(delta: float) -> void:
	var velocity: Vector2 = Input.get_vector("move_left", "move_right", \
			"move_forward", "move_back")
	move_and_slide(velocity * _movement_speed * _movement_speed_multiplier * \
			delta)
	
