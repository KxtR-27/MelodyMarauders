class_name NotePipeContainer extends VBoxContainer

const PIPE_PATH := preload("res://components/scrolling_notes_spawner/note_pipe.tscn")

var note_list : Array = [
	["A", 5],
	["G", 5],
	["F", 5],
	["E", 5],
	["D", 5],
	["C", 5],
	["B", 4],
	["A", 4],
	["G", 4],
	["F", 4],
	["E", 4],
	["D", 4],
	["C", 4]
]

var note_pipes : Dictionary[Array, NotePipe] = {
	#[pitch_name, octave] : NotePipe
}

func create_pipes(speed : int) -> void:
	print("creating pipes")
	for i in range(13):
		var new_note_pipe: NotePipe = PIPE_PATH.instantiate()
		
		add_child(new_note_pipe)
		var spawner: Control = new_note_pipe.get_node("Spawner")
		spawner.global_position.x = 199.0 + (speed * 2)
	
	for i in range(13):
		var pipe : NotePipe = get_child(i)
		var note_array : Array = note_list[i]
		note_pipes[note_array] = pipe
		pipe.name = note_array[0] + str(note_array[1])
	
	note_pipes[["D", 4]].modulate.a = 0
	note_pipes[["F", 4]].modulate.a = 0
	note_pipes[["A", 4]].modulate.a = 0
	note_pipes[["C", 5]].modulate.a = 0
	note_pipes[["E", 5]].modulate.a = 0
	note_pipes[["G", 5]].modulate.a = 0
	
	note_pipes[["A", 5]].modulate.a = 0
	note_pipes[["C", 4]].modulate.a = 0


func spawn_note(note : SequencerNote, speed : int, tempo : int) -> ScrollingNote:
	var pitch_name : String= note.pitch_name
	return note_pipes[[pitch_name, note.octave + 1]].spawn_note(note.beat, speed, tempo)
