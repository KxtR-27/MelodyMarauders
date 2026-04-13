@tool
class_name TrumpetController
extends Node


static var Notes := Note.Notes

static var EMBOUCHURE_INPUT_MAP: Dictionary[String, Note] = {
	"trumpet_open_bottom": Note.new(Notes.C, 4),
	"trumpet_open_left": Note.new(Notes.G, 4),
	"trumpet_open_right": Note.new(Notes.C, 5), 
	"trumpet_open_top": Note.new(Notes.E, 5),
}

## keys are valve combos
## values are the bends required
## this is line-for-line in trumpet fingerings
static var VALVE_BEND_MAP: Dictionary[Array, int] = {
	[false, false, false]: 0,
	[false, true,  false]: -1,
	[true,  false, false]: -2,
	[true,  true,  false]: -3,
	[false, true,  true]:  -4,
	[true,  false, true]:  -5,
	[true,  true,  true]:  -6,
	# apparently you almost never close the third valve alone, 
	# so this is a fallback
	[false, false, true]: 0,
}

@export_group("Instrumentation")
@export var embouchure_input: String = "trumpet_open_bottom"
@export var valve_combo := [false, false, false]
@export var current_note: Note = Note.new(Notes["C"])

@export_group("Debug")
@export var playing: bool = false
@export var accepting_input := true

@onready var note_player: NotePlayer = $NotePlayer


func _ready() -> void:
	_update_current_note()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or not accepting_input: return
	
	var embouchure_changed: bool = _update_embouchure()
	var valves_changed: bool = _update_valve_combo()
	
	if embouchure_changed or valves_changed:
		_update_current_note()
		if Input.is_action_pressed(embouchure_input):
			note_player.play_note(current_note.bend(-2), NotePlayer.Waves.SAW_DOWN, true)
	
	if not embouchure_input or Input.is_action_just_released(embouchure_input):
		note_player.stop_note()


func _update_embouchure() -> bool:
	for input: String in EMBOUCHURE_INPUT_MAP.keys():
		if Input.is_action_just_pressed(input):
			embouchure_input = input
			return true
	
	return false


func _update_valve_combo() -> bool:
	var changed := false
	
	const inputs_array: Array[String] = \
		["trumpet_valve_one", "trumpet_valve_two", "trumpet_valve_three"]
	
	for i in range(0, valve_combo.size()):
		if Input.is_action_pressed(inputs_array[i]) != valve_combo[i]:
			valve_combo[i] = !valve_combo[i]
			changed = true
	
	return changed


func _update_current_note() -> void:
	var open_note: Note = EMBOUCHURE_INPUT_MAP.get(embouchure_input)
	
	if !open_note: 
		return
	
	var valve_bent_note: Note = open_note.bend(VALVE_BEND_MAP[valve_combo])
	current_note = valve_bent_note
