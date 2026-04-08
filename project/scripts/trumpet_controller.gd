@tool
class_name TrumpetController
extends Node


enum OpenNoteTypes { BOTTOM, LEFT, RIGHT, TOP }

static var open_type_map: Dictionary[String, OpenNoteTypes] = {
	"trumpet_open_bottom": OpenNoteTypes.BOTTOM,
	"trumpet_open_left": OpenNoteTypes.LEFT,
	"trumpet_open_right": OpenNoteTypes.RIGHT,
	"trumpet_open_top": OpenNoteTypes.TOP,
}

static var open_note_map: Dictionary[OpenNoteTypes, Note] = {
	OpenNoteTypes.BOTTOM: Note.new(Note.Notes.C, 4),
	OpenNoteTypes.LEFT: Note.new(Note.Notes.G, 4),
	OpenNoteTypes.RIGHT: Note.new(Note.Notes.C, 5),
	OpenNoteTypes.TOP: Note.new(Note.Notes.E, 5),
}

@export var current_open_type: OpenNoteTypes
@export var current_valve_combo: Array[bool] = [false, false, false]
@export var current_note: Note = Note.new()
@export_tool_button("Update Note", "AudioStreamPolyphonic") var upd_n_btn := \
	func() -> void: _update_current_note()

@onready var note_player: NotePlayer = $NotePlayer


func _ready() -> void:
	_update_current_note()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if _update_open_type() or _update_valve_combo():
		_update_current_note()
		note_player.play_note(current_note)


func _update_open_type() -> bool:
	for input: String in open_type_map.keys():
		if Input.is_action_just_pressed(input):
			current_open_type = open_type_map.get(input)
			return true
	
	return false


func _update_valve_combo() -> bool:
	return false


func _update_current_note() -> void:
	current_note = open_note_map.get(current_open_type)
