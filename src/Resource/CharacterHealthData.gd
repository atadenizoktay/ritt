class_name CharacterHealthData
extends Resource


"""
	Node: -
	Type: Resource
	Description: This script contains data related to the health system of the
	characters.
"""


export(float) var _max_hp: float = 4
export(float, 0.2, 1.6, 0.1) var _invul_duration: float = 0.4

var _owner: KinematicBody2D
var _current_hp: float
var is_alive: bool = false
var can_get_hit: bool = true setget _set_can_get_hit
var _InvulTimer: Timer


func reset(owner: KinematicBody2D, invul_timer: Timer) -> void:
	_current_hp = _max_hp
	_owner = owner
	_InvulTimer = invul_timer


func take_damage(damage_amount: float) -> void:
	_current_hp = max(0, _current_hp - damage_amount)
	if not _current_hp:
		if false: # remove
			can_get_hit = false
			is_alive = false
			_owner.die()
	Events.emit_signal("character_health_changed", _owner)


func _set_can_get_hit(can: bool) -> void:
	can_get_hit = can
	if not can_get_hit:
		_InvulTimer.start(_invul_duration)


func _on_InvulTimer_timeout() -> void:
	self.can_get_hit = true
