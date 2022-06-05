class_name PlayerSFXData
extends CharacterSFXData


"""
	Node: -
	Type: Resource
	Description: This script contains data related to the sound effects used
	by the playable characters.
"""


export(String) var windup_sfx_path: String = ""
export(float, -80, 24, 1) var windup_sfx_db: float = -16
export(String) var swing_high_sfx_path: String = ""
export(float, -80, 24, 1) var swing_high_sfx_db: float = -16
export(String) var swing_low_sfx_path: String = ""
export(float, -80, 24, 1) var swing_low_sfx_db: float = -16
