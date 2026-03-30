@tool
extends Node


@export_tool_button("Play Sample Right", "Play") var hit_note_button := \
	func() -> void: _play_hit_note("")
@export_tool_button("Play Sample Wrong", "Node3D") var missed_note_button := \
	func() -> void: _play_missed_note("")
@export_tool_button("Stop Samples", "Stop") var stop_playing_notes := \
	func() -> void: _stop_playing_notes()

# export enum method 1: exported properties with a "fake"
@export_enum("Violin C", "Violin D") var note: int
# export enum method 2: exported a variable of type <actual enum>
enum NOTES {
	VIOLIN_C,
	VIOLIN_D
}

@export var note_actual: NOTES


@onready var violin_hit_C: AudioStreamPlayer = $ViolinHit/AudioStreamPlayer


func _play_hit_note(_note: String) -> void:
	violin_hit_C.play()


func _play_missed_note(_note: String) -> void:
	violin_hit_C.pitch_scale = randf_range(0.5, 1.2)
	# wait until it's done playing, would be a signal from the audiostreamplayer or a manual check
	violin_hit_C.play()
	violin_hit_C.pitch_scale = 1


func _stop_playing_notes() -> void:
	violin_hit_C.stop()
