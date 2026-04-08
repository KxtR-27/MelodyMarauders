class_name BeatButton
extends Button

enum BUTTON_STATE {INACTIVE, ACTIVE, SUSTAIN}

@export var pitch_name : String
@export var accidental : String
@export var octave : int
@export var measure : int
@export var beat : float
@export var instrument : String
@export var inactive_style_box : StyleBoxFlat
@export var active_style_box : StyleBoxFlat
@export var sustain_style_box : StyleBoxFlat
@export var current_button_state : BUTTON_STATE = BUTTON_STATE.INACTIVE

func update_state(button_state : BUTTON_STATE) -> void:
	current_button_state = button_state
	match button_state:
		BUTTON_STATE.INACTIVE:
			add_theme_stylebox_override("normal",inactive_style_box)
			text = ""
		BUTTON_STATE.ACTIVE:
			add_theme_stylebox_override("normal",active_style_box)
		BUTTON_STATE.SUSTAIN: 
			add_theme_stylebox_override("normal",sustain_style_box)
			text = "-"


func update_information(note : String, note_accidental : String, note_octave : int) -> void:
	pitch_name = note
	accidental = note_accidental
	octave = note_octave
	match accidental:
		"natural" : 
			text = pitch_name + str(octave)
		"flat" : 
			text = pitch_name + "♭" + str(octave)
		"sharp" : 
			text = pitch_name + "♯" + str(octave)
