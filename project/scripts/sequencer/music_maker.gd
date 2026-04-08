class_name MusicMaker
extends Node2D

const SAVE_PATH = "user://saves/"
const SEQUENCING_TRACK := preload("res://scenes/sequencer/sequencing_track.tscn")
const INSTRUMENT_NAME_ICON := preload("res://scenes/sequencer/instrument_icon.tscn")
const TOTAL_MEASURES = 16

@export var measures : Dictionary = {}
@export var current_measure : int = 1
@export var current_tempo : int = 90

enum EDITING_MODES {DEACTIVATE, ACTIVATE, SUSTAIN}

var playback_queue : Array = []
var current_editing_mode : EDITING_MODES = EDITING_MODES.ACTIVATE
var current_pitch_name : String = "C"
var current_octave : int = 4
var current_accidental : String = "natural"

var current_note_track : Dictionary = {}

@onready var track_container : TrackContainer = $Main/TrackPanel/Tracks/TrackScrollbar/TrackContainer
@onready var amy_manager : AmyManager = $AmyManager
@onready var measure_timer : Timer = $MeasureTimer

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	_populate_grid()


func _update_button(beat_button : BeatButton) -> void:
	match current_editing_mode:
		EDITING_MODES.DEACTIVATE:
			beat_button.update_state(beat_button.BUTTON_STATE.INACTIVE)
		EDITING_MODES.ACTIVATE:
			beat_button.update_state(beat_button.BUTTON_STATE.ACTIVE)
			beat_button.update_information(
				current_pitch_name, 
				current_accidental, 
				current_octave
			)
		EDITING_MODES.SUSTAIN:
			beat_button.update_state(beat_button.BUTTON_STATE.SUSTAIN)


func _populate_grid() -> void:
	var icon_container := $Main/TrackPanel/Tracks/IconContainer
	
	for instrument : String in amy_manager.instrument_ids.keys():
		var new_instrument_icon := INSTRUMENT_NAME_ICON.instantiate()
		icon_container.add_child(new_instrument_icon)
		
		var label : Label = new_instrument_icon.get_node("Label")
		label.text = instrument
		
		var new_sequencing_track : SequencingTrack = SEQUENCING_TRACK.instantiate()
		track_container.add_child(new_sequencing_track)
		new_sequencing_track.instrument = instrument
		new_sequencing_track.populate_beat_buttons(TOTAL_MEASURES)
		
		for button_index : int in new_sequencing_track.beat_buttons.keys():
			var button : BeatButton = new_sequencing_track.beat_buttons[button_index]
			button.button_down.connect(func() -> void: 
				_update_button(button)
			)
	
	track_container.custom_minimum_size = Vector2(
		(85 * 16 * TOTAL_MEASURES) + 5500, 
		800.0
	)


func _create_measure(measure_num : int) -> Measure:
	var measure : Measure = Measure.new(measure_num)
	for instrument : String in current_note_track.keys():
		var instrument_track : Array = current_note_track[instrument]
		if not instrument_track.is_empty():
			var mismatch : bool = false
			while mismatch == false and not instrument_track.is_empty():
				if instrument_track[0].measure == measure_num:
					measure.notes[measure.notes.size()] = instrument_track[0]
					instrument_track.pop_front()
				else:
					mismatch = true
	
	return measure


func _populate_song() -> void:
	measures.clear()
	current_note_track.clear()
	playback_queue.clear()
	for instrument : String in amy_manager.instrument_ids:
		var track : SequencingTrack = \
				track_container.get_track_by_instrument_name(instrument)
		current_note_track[instrument] = track.get_notes(1)
	
	for i in range(1, TOTAL_MEASURES + 1): 
		measures[i] = _create_measure(i)


func _on_play_from_beginning_button_button_down() -> void:
	_populate_song()
	
	#provide a start time when using the scheduler
	amy_manager.playback_start_time_ms = Time.get_ticks_msec()
	for measure : int in measures.keys():
		playback_queue.push_back(measures[measure])
	
	current_measure = 1
	measure_timer.wait_time = (60.0 / current_tempo) * 4
	
	_play_next_measure()
	measure_timer.start()


func _play_next_measure() -> void:
	if playback_queue.is_empty():
		return
	
	var notes_to_play : Array = []
	var frontmost_measure : Measure = playback_queue[0]
	for note : int in frontmost_measure.notes.keys():
		notes_to_play.append(frontmost_measure.notes[note])
	
	playback_queue.pop_front()
	amy_manager.play_notes_in_array(notes_to_play, current_tempo)


func _on_test_audio_button_button_down() -> void:
	pass # Replace with function body.


func _on_accidentals_value_changed(selection : String) -> void:
	current_accidental = selection
	match current_accidental: 
		"♮": 
			current_accidental = "natural"
		"♭":
			current_accidental = "flat"
		"♯":
			current_accidental = "sharp"


func _on_pitch_buttons_value_changed(selection : String) -> void:
	current_pitch_name = selection


func _on_octave_buttons_value_changed(selection : String) -> void:
	current_octave = int(selection)


func _on_activate_button_button_down() -> void:
	current_editing_mode = EDITING_MODES.ACTIVATE


func _on_deactivate_button_button_down() -> void:
	current_editing_mode = EDITING_MODES.DEACTIVATE


func _on_sustain_button_button_down() -> void:
	current_editing_mode = EDITING_MODES.SUSTAIN


func _on_beat_timer_timeout() -> void:
	_play_next_measure()


func _on_stop_button_button_down() -> void:
	measure_timer.stop()
	measures.clear()
	current_note_track.clear()
	playback_queue.clear()
	amy_manager.amy.panic()


func _on_tempo_field_value_changed(value : int) -> void:
	current_tempo = value


func _save_song_resource() -> void:
	var new_song : Song = Song.new()
	_populate_song()
	
	new_song.measures = measures
	new_song.tempo = current_tempo
	
	var song_title : String
	var line_edit : LineEdit = $Main/SaveInformation/SaveSongVBox/SongTitleLineEdit
	if line_edit.text == "":
		song_title = "newsong"
	else:
		song_title = line_edit.text
	
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_PATH)
		
	ResourceSaver.save(new_song, SAVE_PATH + song_title + ".tres")
	


func _load_song_resource(song_to_load : Song) -> void:
	measures.clear()
	current_note_track.clear()
	playback_queue.clear()
	
	current_tempo = song_to_load.tempo
	var tempo_field : IncrementableField = $Main/SongInformation/SongInformationContainer/TempoField
	var tempo_edit_field : LineEdit = tempo_field.get_node("LineEdit")
	tempo_edit_field.text = str(current_tempo)
	tempo_field.current_value = current_tempo
	var tracks : Array = track_container.get_children()
	
	for track : SequencingTrack in tracks:
		for button_index : int in track.beat_buttons.keys():
			var beat_button : BeatButton = track.beat_buttons[button_index]
			beat_button.update_state(
				BeatButton.BUTTON_STATE.INACTIVE
			)
	
	for measure_index : int in song_to_load.measures.keys():
		var loaded_measure : Measure = song_to_load.measures[measure_index]
		for note_index : int in loaded_measure.notes.keys():
			var current_note : SequencerNote = loaded_measure.notes[note_index]
			var note_attack_index : int = \
					int(((loaded_measure.measure_number - 1) * 16) + \
					((current_note.beat - 1) / 0.25))
			
			var current_track : SequencingTrack = \
			track_container.get_track_by_instrument_name(
				current_note.instrument
			)
			
			var note_attack_button : BeatButton = current_track.beat_buttons[note_attack_index]
			note_attack_button.update_state(BeatButton.BUTTON_STATE.ACTIVE)
			note_attack_button.update_information(
				current_note.pitch_name,
				current_note.accidental,
				current_note.octave
			)
			
			if current_note.length > 0.25:
				var sustain_length : float = current_note.length - 0.25
				var sustain_start : int = note_attack_index + 1
				var notes_to_sustain := sustain_length / 0.25
				for i in range(notes_to_sustain):
					var beat_button : BeatButton = current_track.beat_buttons[sustain_start + i]
					beat_button.update_state(
						BeatButton.BUTTON_STATE.SUSTAIN
					)


func _on_save_song_button_button_down() -> void:
	_save_song_resource()
	var save_gui : Panel = $Main/SaveInformation
	save_gui.visible = false


func _on_cancel_save_button_button_down() -> void:
	var save_gui : Panel = $Main/SaveInformation
	save_gui.visible = false


func _on_save_button_button_down() -> void:
	var save_gui : Panel = $Main/SaveInformation
	save_gui.visible = true


func _on_load_button_button_down() -> void:
	var file_dialog : FileDialog = $Main/FileDialog
	file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	var loaded_song : Song = ResourceLoader.load(path, "Song")
	_load_song_resource(loaded_song)
