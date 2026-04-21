class_name Violin
extends Instrument


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
@export var finger_position_modifier: int = 0

@onready var string_label: Label = $Table/StateLabels/CurrentString
@onready var bow_dir_label: Label = $Table/StateLabels/NextBowDirection


func _process(_delta: float) -> void:
	if not accepting_input: return
	
	_update_current_open_note()
	
	if _check_for_hit():
		last_bow_dir_was_up = not last_bow_dir_was_up
		var bend_factor: int = current_finger_position
		
		if Input.is_action_pressed("violin_lower_current_finger"):
			bend_factor -= 1
		elif Input.is_action_pressed("violin_higher_current_finger"):
			bend_factor += 1
			
		play_note(current_open_note.bend(bend_factor))


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
