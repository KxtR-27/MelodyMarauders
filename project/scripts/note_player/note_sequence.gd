@tool
class_name NoteSequence
extends Resource


enum Waves {
	SINE = 0, 
	PULSE = 1,
	SAW_DOWN = 2,
	SAW_UP = 3,
	TRIANGLE = 4,
	NOISE = 5,
}

@export var waveform: Waves = Waves.SINE

@export var notes: Array[NoteEntry] = []


func _init() -> void:
	self.notes = [];
	self.waveform = Waves.SINE


func get_notes() -> Array[NoteEntry]: 
	return notes
