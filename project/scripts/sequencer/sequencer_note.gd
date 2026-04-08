class_name SequencerNote extends Resource

@export var pitch_name : String
@export var accidental : String
@export var octave : int
@export var measure : int
@export var beat : float
@export var length : float
@export var instrument : String

func _init(
	note_pitch : String = "C", 
	note_accidental : String = "natural", 
	note_octave : int = 4, 
	note_measure : int = 1, 
	note_beat : float = 1, 
	note_length : float = 0.25, 
	note_instrument : String = ""
	) -> void:
	self.pitch_name = note_pitch
	self.accidental = note_accidental
	self.octave = note_octave
	self.measure = note_measure
	self.beat = note_beat
	self.length = note_length
	self.instrument = note_instrument
