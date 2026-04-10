class_name SequencingTrack extends Panel

@export var instrument : String
const BUTTON_SCENE := preload("res://scenes/sequencer/beat_button.tscn")
var beat_buttons : Dictionary = {}
var last_note : SequencerNote

func populate_beat_buttons(total_measures : int) -> void:
	var total_buttons : int = total_measures * 16
	var buttons_until_separator : int = 4
	var buttons_until_new_measure : int = 16
	
	for i in range(total_buttons):
		var new_button : BeatButton = BUTTON_SCENE.instantiate()
		$ButtonContainer.add_child(new_button)
		new_button.instrument = instrument
		new_button.measure = 1 + floori( i / 16 )
		new_button.beat = 1.0 + ((i % 16) * 0.25)
		
		beat_buttons[i] = new_button
		
		if ((i + 1) % buttons_until_separator == 0):
			var new_separator : VSeparator = VSeparator.new()
			$ButtonContainer.add_child(new_separator)
		
		var measure_label : Label = new_button.get_node("MeasureLabel")
		if (i % buttons_until_new_measure == 0):
			measure_label.text = "Measure " + str(new_button.measure)
		else:
			measure_label.text = ""


func get_notes(starting_measure : int) -> Array:
	last_note = null
	var end_point : int = beat_buttons.size()
	var start_point : int = (starting_measure - 1) * 16
	var notes : Array = []
	
	for i in range(start_point, end_point):
		var beat_button : BeatButton = beat_buttons[i]
		match beat_button.current_button_state:
			beat_button.BUTTON_STATE.ACTIVE:
				print("note created!")
				last_note = SequencerNote.new(
					beat_button.pitch_name,
					beat_button.accidental,
					beat_button.octave,
					beat_button.measure,
					beat_button.beat,
					0.25,
					beat_button.instrument
				)
				notes.append(last_note)
			beat_button.BUTTON_STATE.SUSTAIN:
				if last_note != null:
					last_note.length += 0.25
			beat_button.BUTTON_STATE.INACTIVE:
				last_note = null
		
	return notes
