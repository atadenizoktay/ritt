class_name PlayerCombatStats
extends Resource


"""
	Node: -
	Type: Resource
	Description: This script contains data related to the combat stats of
	playable characters.
"""


export(int, 100, 1000, 10) var max_movement_speed: int = 120
export(int, 1280, 3840, 10) var movement_acceleration: int = 2560
export(int, 10, 100, 1) var weapon_stack_rotation_speed: int = 52
