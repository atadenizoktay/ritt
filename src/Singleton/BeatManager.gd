extends Node


"""
	Node: BeatManager
	Type: Singleton
	Description: This script controls the beat of the game.
"""


signal beat_dropped

const _MIDI_FILE_BEAT_COUNT: int = 64

var _beat_index: int = 0
var _current_beat_counter: MidiPlayer = null

onready var _MidiPlayerScene: PackedScene = load( \
		"res://addons/midi/MidiPlayer.tscn")
onready var _beat_midi_file_path: String = "res://assets/audio/beat/main.mid"
onready var _BeatPlayer: AudioStreamPlayer = $BeatPlayer


func _ready() -> void:
	_create_a_beat_counter()


func _create_a_beat_counter() -> void:
	if _current_beat_counter:
		_current_beat_counter.queue_free()
		yield(_BeatPlayer, "finished")
	var beat_counter: MidiPlayer = _MidiPlayerScene.instance()
	beat_counter.file = _beat_midi_file_path
	beat_counter.connect("midi_event", self, "_on_beat_counter_midi_event")
	add_child(beat_counter)
	_current_beat_counter = beat_counter
	beat_counter.play()
	_BeatPlayer.play()


func _on_beat_counter_midi_event(\
		_channel: MidiPlayer.GodotMIDIPlayerChannelStatus, \
		event: SMF.MIDIEvent) -> void:
	if event.type == SMF.MIDIEventType.note_on:
		_beat_index += 1
		if _beat_index == _MIDI_FILE_BEAT_COUNT - 1:
			_beat_index = 0
			_create_a_beat_counter()
		emit_signal("beat_dropped")
