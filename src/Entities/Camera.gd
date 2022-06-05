extends Camera2D


"""
	Node: Camera
	Type: Entity
	Description: This script controls the main scene camera of the game.
"""


const _MIN_SHAKE_POWER: int = 1

export(Vector2) var _beat_zoom_in_vector: Vector2 = Vector2(0.92, 0.92)
export(float, 0.2, 1.6, 0.01) var _beat_zoom_tween_duration: float = 0.4
export(int, 4, 64, 1) var _max_shake_power: int = 32
export(float, 0.2, 1.6, 0.01) var _screen_shake_duration: float = 0.6

var _current_shake_power: int = 1

onready var _Tween: Tween = $Tween


func _ready() -> void:
	_initialize_signal_connections()


func _physics_process(_delta: float) -> void:
	_control_screen_shake()
	
	
func _initialize_signal_connections() -> void:
	BeatManager.connect("beat_dropped", self, "_on_beat_dropped")


func _control_screen_shake() -> void:
	var rand_x: int = int(rand_range(-_max_shake_power, _max_shake_power)) % \
			_current_shake_power
	var rand_y: int = int(rand_range(-_max_shake_power, _max_shake_power)) % \
			_current_shake_power
	offset = Vector2(rand_x, rand_y)
	

func _shake_the_screen() -> void:
	_Tween.remove(self, "_current_shake_power")
	_Tween.interpolate_property(self, "_current_shake_power", _max_shake_power, \
			_MIN_SHAKE_POWER, _screen_shake_duration, Tween.TRANS_QUAD, \
			Tween.EASE_OUT)
	_Tween.start()
	

# Creates the heartbeat effect.
func _on_beat_dropped() -> void:
	_Tween.remove(self, "zoom")
	_Tween.interpolate_property(self, "zoom", _beat_zoom_in_vector, \
			Vector2(1, 1), _beat_zoom_tween_duration, Tween.TRANS_ELASTIC, \
			Tween.EASE_OUT)
	_Tween.start()
