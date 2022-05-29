class_name CharacterCombatStats
extends Resource


"""
	Node: -
	Type: Resource
	Description: This script contains data related to the combat stats of
	all characters.
"""


export(int, 10, 1000, 1) var max_movement_speed: int = 120
export(int, 1280, 3840, 10) var movement_acceleration: int = 2560
