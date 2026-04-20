class_name StaffMinigame extends Node2D

@export var scroll_speed : int = 500
@export var beats_elapsed : int = 0
@export var measure : int = 0
@export var tempo : int = 0
@export var current_instrument : String = "Sine"
@export var song : Song

@export var current_track : Array = []
@export var playback_queue : Array = []
@export var measures : Dictionary = {}

@export var spawner : ScrollingNoteSpawner
@export var measure_timer : Timer

@export var amy_manager : AmyManager

var notes_hit : int = 0
var notes_missed : int = 0
var total_notes : int = 0
var current_note : ScrollingNote
var offset_interval : float = 20.0
var note_offsets : Dictionary = {
	"B" = 6,
	"A" = 5,
	"G" = 4,
	"F" = 3,
	"E" = 2,
	"D" = 1,
	"C" = 0
}

@onready var cursor : Area2D = $Cursor
@onready var initial_cursor_position : Vector2 = cursor.global_position
#@onready var controller : TrumpetControllerForSequencer = $AmyManager/TrumpetControllerForSequencer

signal note_pipes_requested
signal spawn_note_requested(note : SequencerNote, speed : int, tempo : int)
signal song_finished
signal score_tallied(hit_percentage : float)

func create_song(new_song : Song) -> void:
	note_pipes_requested.emit(scroll_speed)
	
	for measure_index : int in new_song.measures.keys():
		var loaded_measure : Measure = new_song.measures[measure_index]
		measures[measure_index] = loaded_measure
		for note_index : int in loaded_measure.notes.keys():
			var note_at_index : SequencerNote = loaded_measure.notes[note_index]
			if note_at_index.instrument == current_instrument:
				current_track.push_back(note_at_index)
	
	measures.sort()
	var last_populated_measure : Measure = null
	for measure_index : int in measures:
		var loaded_measure : Measure = measures[measure_index]
		if not loaded_measure.notes.is_empty():
			last_populated_measure = loaded_measure
	
	if last_populated_measure.measure_number != measures.size():
		for i in range(last_populated_measure.measure_number + 1, measures.size()):
			measures.erase(i)


func _play_next_measure() -> bool:
	if playback_queue.is_empty() or measure == measures.size():
		song_finished.emit()
		return false
	
	var notes_to_play : Array = []
	var frontmost_measure : Measure = playback_queue[0]
	for note_index : int in frontmost_measure.notes.keys():
		var note : SequencerNote = frontmost_measure.notes[note_index]
		if note.instrument != current_instrument:
			notes_to_play.append(note)
	
	playback_queue.pop_front()
	
	_spawn_measure(measure)
	amy_manager.play_notes_in_array(notes_to_play, tempo, 1000)
	measure += 1
	
	return true


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
		measure_timer.stop()
	
	if not notes_to_spawn.is_empty():
		for note : SequencerNote in notes_to_spawn:
			spawn_note_requested.emit(note, scroll_speed, tempo)
			#var new_note : ScrollingNote = spawner.spawn_note(note, scroll_speed, tempo)
			#new_note.pitch_name = note.pitch_name
			#new_note.octave = note.octave
			total_notes += 1


func _play_song() -> void:
	playback_queue.clear()
	amy_manager.amy.panic()
	
	for measure_index : int in measures.keys():
		playback_queue.push_back(measures[measure_index])
	
	measure = 1
	measure_timer.wait_time = (60.0 / tempo) * 4
	amy_manager.playback_start_time_ms = Time.get_ticks_msec()
	
	_play_next_measure()
	measure_timer.start()
	await song_finished
	
	await measure_timer.timeout
	measure_timer.stop()
	# ternary -- if there's a %, return that, otherwise return 100%
	score_tallied.emit(_get_score_percent() if _get_score_percent() else 1.00)


func _load_song(new_song : Song) -> void:
	song = new_song
	current_track.clear()
	tempo = new_song.tempo
	create_song(new_song)


func _on_measure_timer_timeout() -> void:
	_play_next_measure()



func _on_clear_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("ScrollingNotes"):
		area.queue_free()


func _on_trumpet_controller_for_sequencer_note_started(note_name: String, octave: int) -> void:
	if current_note:
		if current_note.pitch_name == note_name and current_note.octave == (octave - 1):
			current_note.queue_free()
			current_note = null
			
			notes_hit += 1
			_update_score()


func _on_trumpet_controller_for_sequencer_note_stopped() -> void:
	pass


func _on_cursor_area_entered(area: Area2D) -> void:
	if area is ScrollingNote:
		current_note = area


func _on_cursor_area_exited(area: Area2D) -> void:
	if area == current_note:
		current_note = null
		notes_missed += 1
		_update_score()


func _update_score() -> void:
	var format_text : String = "Hit: %d / %d (%.2f)"
	var actual_text : String = format_text % [notes_hit, total_notes, _get_score_percent()]
	var score_label : Label = get_parent().get_node("MainControl/ScoreLabel")
	score_label.text = actual_text


func _get_score_percent() -> float:
	return (float(notes_hit) / float(total_notes))


func _on_song_finished() -> void:
	pass


func reset() -> void:
	current_track.clear()
	playback_queue.clear()
	measures.clear()


func _on_score_tallied(hit_percentage: float) -> void:
	var format_text: String = "accuracy: %.2f%s" % [hit_percentage, "%"]
