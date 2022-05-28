extends Node


"""
	Node: AudioManager
	Type: Singleton
	Description: This script controls the audio of the game.
"""


signal beat_dropped

onready var _BeatPlayer: AudioStreamPlayer = $BeatPlayer
onready var _BeatCounter: MidiPlayer = $BeatCounter


func _ready() -> void:
	_initialize_beat_related_nodes()


func _initialize_beat_related_nodes() -> void:
	_BeatPlayer.play()
	_BeatCounter.play()
	
	
func _on_BeatCounter_midi_event(\
		_channel: MidiPlayer.GodotMIDIPlayerChannelStatus, \
		event: SMF.MIDIEvent) -> void:
	if event.type == SMF.MIDIEventType.note_on:
		emit_signal("beat_dropped")
