@tool
class_name Note
extends Resource


enum Notes {
	C = 0,
	C_SHARP = 1, 
	D_FLAT = 1,
	D = 2,
	D_SHARP = 3, 
	E_FLAT = 3,
	E = 4,
	F = 5,
	F_SHARP = 6,
	G_FLAT = 6,
	G = 7,
	G_SHARP = 8,
	A_FLAT = 8,
	A = 9,
	A_SHARP = 10,
	B_FLAT = 10,
	B = 11,
}

static var starting_frequency := 16.35 # C0

@export var note: Notes = Notes.C:
	set(new_note):
		note = new_note
		debug_frequency = self.get_frequency()
@export_range(0, 9) var octave: int = 4:
	set(new_octave):
		octave = new_octave
		debug_frequency = self.get_frequency()
@export_range(0, 60, 0.01, "hide_control", "or_greater", "suffix:seconds") \
	var sustain: float = 1.0

@export_group("Debug")
@export var debug_frequency: float


func _init(n: Notes = Notes.C, o: int = 4, s: float = 1.0) -> void:
	self.note = n
	self.octave = o
	self.sustain = s


func get_frequency() -> float:
	return (starting_frequency * pow(2, octave)) * pow(2, note/12.0)
