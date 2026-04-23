class_name DefenseMinigame extends Node2D

var chord_pool : Dictionary[String, Array] = {
	"C Major" : ["C", "E", "G"],
	"D Minor" : ["D", "F", "A"],
	"E Minor" : ["E", "G", "B"],
	"F Major" : ["F", "A", "C"],
	"G Major" : ["G", "B", "D"],
	"A Minor" : ["A", "C", "E"],
	"B Dim" : ["B", "D", "F"]
}

var panel_note_states : Array = [0, 0, 0]
var note_names : Array = ["C", "D", "E", "F", "G", "A", "B"]

var current_chord : Array = []

var selected_panel : int = 0

@onready var chord_label: Label = $MainControl/TopVBox/ChordLabel

signal answer_submitted(accuracy : float)

func _ready() -> void:
	var ran_int : int = randi_range(0,6)
	var ran_chord : String = chord_pool.keys()[ran_int]
	current_chord = chord_pool[ran_chord]
	
	($MainControl/TopVBox/ChordLabel as Label).text = ran_chord
	
	_redraw_panels()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		_update_panel(selected_panel, "up")
	
	if Input.is_action_just_pressed("down"):
		_update_panel(selected_panel, "down")
	
	if Input.is_action_just_pressed("left"):
		_switch_panel("left")
	
	if Input.is_action_just_pressed("right"):
		_switch_panel("right")
	
	if Input.is_action_just_pressed("skip_prompt"):
		var accuracy := _calculate_accuracy()
		answer_submitted.emit(accuracy)

func _update_panel(panel_index : int, direction : String) -> void:
	match direction:
		"up":
			panel_note_states[panel_index] += 1
			if panel_note_states[panel_index] == note_names.size():
				panel_note_states[panel_index] = 0
				
		"down":
			panel_note_states[panel_index] -= 1
			if panel_note_states[panel_index] < 0:
				panel_note_states[panel_index] = note_names.size() - 1
	
	_redraw_panels()

func _switch_panel(direction : String) -> void:
	match direction:
		"left":
			selected_panel -= 1
			if selected_panel < 0:
				selected_panel = panel_note_states.size() - 1
		"right":
			selected_panel += 1
			if selected_panel == panel_note_states.size():
				selected_panel = 0
	
	_redraw_panels()


func _redraw_panels() -> void:
	($MainControl/CenterHBox/NotePanel/NoteText as Label).text = note_names[panel_note_states[0]]
	($MainControl/CenterHBox/NotePanel2/NoteText as Label).text = note_names[panel_note_states[1]]
	($MainControl/CenterHBox/NotePanel3/NoteText as Label).text = note_names[panel_note_states[2]]
	
	match selected_panel:
		0: 
			($MainControl/CenterHBox/NotePanel/NoteText as Label).add_theme_color_override("font_color", Color.WHITE)
			($MainControl/CenterHBox/NotePanel2/NoteText as Label).add_theme_color_override("font_color", Color.WEB_GRAY)
			($MainControl/CenterHBox/NotePanel3/NoteText as Label).add_theme_color_override("font_color", Color.WEB_GRAY)
		1:
			($MainControl/CenterHBox/NotePanel/NoteText as Label).add_theme_color_override("font_color", Color.WEB_GRAY)
			($MainControl/CenterHBox/NotePanel2/NoteText as Label).add_theme_color_override("font_color", Color.WHITE)
			($MainControl/CenterHBox/NotePanel3/NoteText as Label).add_theme_color_override("font_color", Color.WEB_GRAY)
		2:
			($MainControl/CenterHBox/NotePanel/NoteText as Label).add_theme_color_override("font_color", Color.WEB_GRAY)
			($MainControl/CenterHBox/NotePanel2/NoteText as Label).add_theme_color_override("font_color", Color.WEB_GRAY)
			($MainControl/CenterHBox/NotePanel3/NoteText as Label).add_theme_color_override("font_color", Color.WHITE)


func _on_answer_submitted(accuracy : float) -> void:
	var formatted_string : String = "You answered with %.0f%s accuracy!" % [(accuracy * 100), "%"]
	($MainControl/TopVBox/ChordLabel as Label).text = formatted_string


func _calculate_accuracy() -> float:
	var correct_notes : int = 0
	
	if ($MainControl/CenterHBox/NotePanel/NoteText as Label).text == current_chord[0]:
		correct_notes += 1
	if ($MainControl/CenterHBox/NotePanel2/NoteText as Label).text == current_chord[1]:
		correct_notes += 1
	if ($MainControl/CenterHBox/NotePanel3/NoteText as Label).text == current_chord[2]:
		correct_notes += 1
	
	var accuracy : float = correct_notes / 3.0
	
	return accuracy
