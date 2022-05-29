class_name CharacterCombatStatsData
extends Resource


"""
	Node: -
	Type: Resource
	Description: This script contains data related to the combat stats of
	all characters.
"""


const MAX_WOBBLE_KNOCKBACK_VECTOR_LENGTH: int = 100

export(int, 10, 1000, 1) var max_movement_speed: int = 120
export(int, 1280, 3840, 10) var movement_acceleration: int = 2560
export(int, 10, 1000, 1) var knockback_power: int = 250
export(float, 0.1, 1.6, 0.01) var knockback_duration: float = 0.32
