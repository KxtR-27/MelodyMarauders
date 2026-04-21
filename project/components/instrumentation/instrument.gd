@tool @abstract
class_name Instrument
extends MarginContainer
# this is in the components folder because it is its own extendable class
# that extends Node, an actual component


signal played_note(note: Note, correctly: bool)

@export var wave: NotePlayer.Waves
@export var accepting_input := true
@export var show_table := true:
	set(update):
		show_table = update
		if table:
			table.visible = show_table
		property_list_changed.emit()

@export_group("When Prompted")
@export var must_play_correctly := false
@export var correct_note: Note

@onready var note_player: NotePlayer = $NotePlayer
@onready var table: Container = $Table


func play_note(note: Note) -> void:
	if must_play_correctly and not note == correct_note:
		note_player.play_extra(note, wave)
		played_note.emit(note, false)
	else:
		note_player.play_note(note, wave)
		played_note.emit(note, true)
