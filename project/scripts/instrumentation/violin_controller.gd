@tool
class_name ViolinController
extends Node


static var open_notes_map: Dictionary[String, Note] = {
	"violin_open_g": Note.new(Note.Notes.G, 3, 0.5), 
	"violin_open_d": Note.new(Note.Notes.D, 4, 0.5), 
	"violin_open_a": Note.new(Note.Notes.A, 4, 0.5), 
	"violin_open_e": Note.new(Note.Notes.E, 5, 0.5),
}

static var finger_position_values: Dictionary[String, int] = {
	"violin_finger_first": 2,
	"violin_finger_second": 4,
	"violin_finger_third": 5,
	"violin_finger_fourth": 7,
}

# start with down-bow
@export var last_bow_dir_was_up := true
@export var current_open_note: Note = open_notes_map.get("violin_open_d")
@export var current_finger_position: int = 0

@export var accepting_input := true

@onready var note_player: NotePlayer = $NotePlayer


func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or not accepting_input:
		return
	
	_update_current_open_note()
	
	var hit_occurred: bool = _check_for_hit()
	if hit_occurred:
		print("note played!")
		last_bow_dir_was_up = not last_bow_dir_was_up
		note_player.play_note(current_open_note.bend(current_finger_position), NotePlayer.Waves.SAW_DOWN)


func _update_current_open_note() -> void:
	var holding_finger := false
	
	for finger_position: String in finger_position_values.keys():
		if Input.is_action_pressed(finger_position):
			current_finger_position = finger_position_values.get(finger_position)
			holding_finger = true
	
	if not holding_finger: 
		current_finger_position = 0
	
	for open_input: String in open_notes_map.keys():
		if Input.is_action_just_pressed(open_input):
			print("note changed!")
			current_open_note = open_notes_map.get(open_input)


func _check_for_hit() -> bool:
	var hit_down: bool = (
		Input.is_action_just_pressed("violin_bow_down") 
		and last_bow_dir_was_up
	)
	var hit_up: bool = (
		not hit_down 
		and Input.is_action_just_pressed("violin_bow_up") 
		and not last_bow_dir_was_up
	)
	
	return hit_down or hit_up;
