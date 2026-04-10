class_name ScrollingStaffGenerator extends Node2D

@export var scroll_speed : int = 250
@export var beats_elapsed : int = 0
@export var measure : int = 0
@export var tempo : int = 0
@export var current_instrument : String = "Sine"

@export var amy_manager : AmyManager
@export var current_track : Array = []


func _create_song(song : Song) -> void:
	for measure_index : int in song.measures.keys():
		var loaded_measure : Measure = song.measures[measure_index]
		for note_index : int in loaded_measure.notes.keys():
			var current_note : SequencerNote = loaded_measure.notes[note_index]
			if current_note.instrument == current_instrument:
				current_track.push_back(current_note)


func _spawn_note(note : SequencerNote) -> void:
	pass


func _spawn_measure(measure_num : int) -> void:
	var notes_to_spawn : Array = []
	
	if not current_track.is_empty():
			var mismatch : bool = false
			while mismatch == false and not current_track.is_empty():
				var next_note : SequencerNote = current_track[0]
				if current_track[0].measure == measure_num:
					notes_to_spawn.append(next_note)
					current_track.pop_front()
				else:
					mismatch = true
	else:
		var measure_timer : Timer = $MeasureTimer
		measure_timer.stop()
	
	if not notes_to_spawn.is_empty():
		for note : SequencerNote in notes_to_spawn:
			_spawn_note(note)


func _play_song() -> void:
	measure = 0
	_spawn_measure(0)
	measure += 1
	
	var measure_timer : Timer = $MeasureTimer
	measure_timer.start()


func _load_song(song : Song) -> void:
	current_track.clear()
	tempo = song.tempo
	_create_song(song)


func _on_load_button_button_down() -> void:
	var file_dialog : FileDialog = $FileDialog
	file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	#var label : Label = $MainControl/LoadSongHBox/CurrentSongLabel
	var loaded_song : Song = ResourceLoader.load(path, "Song")
	_load_song(loaded_song)
	#TODO: update 'current song' label


func _on_clear_area_body_entered(body: Node2D) -> void:
	if body.name == "ScrollingNote":
		body.queue_free()


func _on_measure_timer_timeout() -> void:
	_spawn_measure(measure)
	measure += 1
