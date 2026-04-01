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

@export_group("Playback")
@export var waveform: Waves = Waves.SINE
@export_custom(PROPERTY_HINT_NONE, "suffix:x speed") \
	var speedFactor: float = 1.0
@export_range(-48, 38, 1, "suffix:half steps") \
	var pitch_offset: int = 0
@export_tool_button("Sync speed to pitch offset", "Timer") var sync_button := \
	func() -> void: speedFactor = 1 + (pitch_offset / 12.0) 

@export_group("Notes")
@export var notes: Array[Note] = []


func _init() -> void:
	self.notes = [];
	self.waveform = Waves.SINE


func get_notes() -> Array: 
	return notes.map(func(note: Note) -> \
		Note: return Note.new(
			note.note + pitch_offset, 
			note.octave, 
			note.sustain * (1.0 / speedFactor)
		)
	)
