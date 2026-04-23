class_name ScrollingNoteSpawner extends Node2D

const OCTAVE_OFFSET : int = 5
const SCROLLING_NOTE = preload("res://components/scrolling_notes_spawner/scrolling_note.tscn")

var offset_interval : float = 35.0
var default_offset : float = offset_interval * 7
var note_offsets : Dictionary = {
	"B" = 6,
	"A" = 5,
	"G" = 4,
	"F" = 3,
	"E" = 2,
	"D" = 1,
	"C" = 0
}


func spawn_note(note : SequencerNote, speed : int, tempo : int) -> ScrollingNote:
	var octave : int = note.octave - OCTAVE_OFFSET
	
	var new_scrolling_note : ScrollingNote = SCROLLING_NOTE.instantiate()
	
	add_child(new_scrolling_note)
	
	var y_offset : float = calculate_y_offset(note.pitch_name, note.octave)
	var x_offset : float = calculate_x_offset(note.beat, speed, tempo)
	
	new_scrolling_note.global_position = self.global_position
	new_scrolling_note.global_position.x += x_offset
	new_scrolling_note.global_position.y -= y_offset + 140.0
	new_scrolling_note.speed = speed
	
	return new_scrolling_note


func calculate_y_offset(note_name : String, octave : int) -> float:
	var offset : float = offset_interval * note_offsets[note_name]
	offset += (octave - OCTAVE_OFFSET) * (offset_interval * 7)
	
	return offset


func calculate_x_offset(beat : float, speed : int, tempo : int) -> float:
	var pulse : float = 60.0/tempo
	var offset : float = (beat - 1) * pulse * speed
	
	return offset
