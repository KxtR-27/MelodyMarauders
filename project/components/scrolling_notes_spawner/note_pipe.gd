class_name NotePipe extends Control

const SCROLLING_NOTE = preload("res://components/scrolling_notes_spawner/scrolling_note.tscn")
@onready var spawner : Control = $Spawner

func spawn_note(beat : float, speed : int, bpm : int) -> ScrollingNote:
	var new_note : ScrollingNote = SCROLLING_NOTE.instantiate()
	add_child(new_note)
	new_note.global_position = spawner.global_position
	new_note.global_position.x += _calculate_x_offset(beat, speed, bpm)
	new_note.speed = speed
	print("spawning note at " + name)
	return new_note


func _calculate_x_offset(beat : float, speed : int, tempo : int) -> float:
	var pulse : float = 60.0/tempo
	var offset : float = (beat - 1) * pulse * speed
	
	return offset
