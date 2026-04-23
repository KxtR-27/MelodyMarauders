@tool
class_name TrumpetControllerForSequencer
extends Node

signal note_started(note_name : String, octave : int)
signal note_stopped()

static var Notes := Note.Notes

static var EMBOUCHURE_INPUT_MAP: Dictionary[String, int] = {
	"trumpet_open_bottom": 0,
	"trumpet_open_left": 1,
	"trumpet_open_top": 2,
	"trumpet_open_right": 3, 
}

static var PITCH_MAP : Dictionary = {
	"C" : 0,
	"D" : 2,
	"E" : 4,
	"F" : 5,
	"G" : 7,
	"A" : 9,
	"B" : 11,
}

## keys are valve combos
## values are embouchure arrays
## this is line-for-line in trumpet fingerings
static var NOTE_MAP: Dictionary[Array, Array] = {
	[false, false, false]: [["C", 4, "natural"],       ["G", 4, "natural"],       ["C", 5, "natural"],        ["E", 5, "natural"]],
	[false, true,  false]: [["B", 3, "natural"],       ["F", 4, "sharp"],         ["B", 4, "natural"],        ["D", 5, "sharp"]],
	[true,  false, false]: [["B", 3, "flat"],          ["F", 4, "natural"],       ["B", 4, "flat"],           ["D", 5, "natural"]],
	[true,  true,  false]: [["A", 3, "natural"],       ["E", 4, "natural"],       ["A", 4, "natural"],        ["C", 5, "sharp"]],
	[false, true,  true]:  [["G", 3, "sharp"],         ["D", 4, "sharp"],         ["G", 4, "sharp"],          ["G", 4, "sharp"]],
	[true,  false, true]:  [["G", 3, "natural"],       ["D", 4, "natural"],       ["D", 4, "natural"],        ["D", 4, "natural"]],
	[true,  true,  true]:  [["F", 3, "sharp"],         ["C", 4, "natural"],       ["C", 4, "natural"],        ["C", 4, "natural"]],
	
	# apparently you almost never close the third valve alone. 
	# like, it's weird. I cannot find a fingering chart that has an embouchure for just the third valve.
	# even my twin sister says you almost never hold only the third valve.
	# BUT. since it's technically an input option, the below is to appease the code throwing Nil
	# have fun with the exact same embouchure as open lol
	[false, false, true]:  [["C", 4, "natural"],       ["G", 4, "natural"],       ["C", 5, "natural"],        ["E", 5, "natural"]],
}

@export var amy_manager : AmyManager

@export_group("Instrumentation")
@export var embouchure: int
@export var valve_combo := [false, false, false]
@export var current_note: Array = ["C", 4, "natural"]

@export_group("Debug")
@export var playing: bool = false
@export var accepting_input := true

var embouchure_input: String
#var current_note: Note = Note.new()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or not accepting_input: return
	
	var changed_embouchure: bool = _update_embouchure()
	var changed_valve_combo: bool = _update_valve_combo()
	
	if changed_embouchure or changed_valve_combo:
		_update_current_note()
	
	if (
		# face button was pressed
		(embouchure_input != "" and Input.is_action_just_pressed(embouchure_input))
		# or already playing pressed face button and valves changed or other face button pressed
		or (playing and (changed_embouchure or changed_valve_combo))
	):
		var midi_note : int = get_midi_note(current_note)
		amy_manager.start_sustain("Sine", midi_note)
		note_started.emit(current_note[0], current_note[1])
		playing = true
	
	# face button released
	if embouchure_input and Input.is_action_just_released(embouchure_input):
		var midi_note : int = get_midi_note(current_note)
		amy_manager.stop_sustain("Sine", midi_note)
		embouchure_input = ""
		note_stopped.emit()
		playing = false


func _update_embouchure() -> bool:
	for input: String in EMBOUCHURE_INPUT_MAP.keys():
		if Input.is_action_just_pressed(input):
			embouchure_input = input
			embouchure = EMBOUCHURE_INPUT_MAP.get(input)
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


func get_midi_note(note_array : Array) -> int:
	var pitch_name : String = note_array[0]
	var octave : int = note_array[1]
	var accidental : String = note_array[2]
	
	var midi_note : int = 0
	midi_note += PITCH_MAP[pitch_name]
	midi_note += 12 * octave
	match accidental:
		"sharp":
			midi_note += 1
		"flat":
			midi_note -= 1
	
	return midi_note


func _update_current_note() -> void:
	var old_note : Array = current_note
	
	var new_note: Array = NOTE_MAP.get(valve_combo)[embouchure]
	if new_note:
		current_note = new_note
		
	if not old_note.is_empty():
		var midi_note : int = get_midi_note(old_note)
		amy_manager.stop_sustain("Sine", midi_note)
