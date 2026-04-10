class_name Measure extends Resource

@export var measure_number : int = 1
@export var notes : Dictionary = {}

func _init(measure_num : int = 1) -> void:
	self.measure_number = measure_num


func add_note(note : SequencerNote) -> void:
	var current_size : int = notes.size()
	notes[current_size] = note
