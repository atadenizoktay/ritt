class_name CharacterHealthData
extends Resource


"""
	Node: -
	Type: Resource
	Description: This script contains data related to the health system of the
	characters.
"""


export(float) var _max_hp: float = 4

var _owner: KinematicBody2D
var _current_hp: float


func reset() -> void:
	_current_hp = _max_hp


func take_damage(damage_amount: float) -> void:
	_current_hp = max(0, _current_hp - damage_amount)
	Events.emit_signal("character_health_changed", _owner)


func heal(heal_amount: float) -> void:
	_current_hp = min(_max_hp, _current_hp + heal_amount)
