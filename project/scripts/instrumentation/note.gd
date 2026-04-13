@tool
class_name Note
extends Resource


static var Notes: Dictionary[String, int] = {
	"C" = 0,
	"C#" = 1, 
	"Db" = 1,
	"D" = 2,
	"D#" = 3, 
	"Eb" = 3,
	"E" = 4,
	"F" = 5,
	"F#" = 6,
	"G_FLAT" = 6,
	"G" = 7,
	"G_SHARP" = 8,
	"A_FLAT" = 8,
	"A" = 9,
	"A_SHARP" = 10,
	"B_FLAT" = 10,
	"B" = 11,
}

static var starting_frequency := 16.35 # C0

@export var note := Notes["C"]:
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


func _init(n := Notes["C"], o: int = 4, s: float = 1.0) -> void:
	self.note = n
	self.octave = o
	self.sustain = s


func _to_string() -> String:
	return "Note %s%d (%.2f Hz)" % [Notes.find_key(note), octave, get_frequency()]


func get_frequency() -> float:
	return (starting_frequency * pow(2, octave)) * pow(2, note/12.0)


func bend(half_steps: int) -> Note:
	var bent_note: int = self.note + half_steps
	var bent_octave: int
	
	if bent_note >= 12:
		bent_octave = self.octave + 1
		bent_note -= 12
	elif bent_note <= -1:
		bent_octave = self.octave - 1
		bent_note += 12
	else:
		bent_octave = self.octave
	
	return Note.new(bent_note, bent_octave, self.sustain) 


func transpose(half_steps: int) -> Note:
	return bend(half_steps)
