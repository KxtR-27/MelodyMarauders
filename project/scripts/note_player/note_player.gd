@tool
class_name NotePlayer 
extends Node


## emits when a note starts playing
signal note_played(note: Note)
## emits when a note stops playing
signal note_stopped(note: Note)
## emits when a sequence starts playing
signal sequence_played(sequence: NoteSequence)
## emits when a sequence stops playing
signal sequence_stopped(sequence: NoteSequence)

const starting_frequency := 16.35 # C0

@export var note_sequence: NoteSequence = NoteSequence.new()
@export_tool_button("Play Sequence", "AudioStreamWAV") var play_sequence_button := \
	func() -> void: play_sequence(note_sequence)

@export_group("Note Preview")
@export var preview_waveform: NoteSequence.Waves = NoteSequence.Waves.SINE
@export var preview_note: Note = Note.new()
@export_tool_button("Play Preview", "AudioListener2D") var preview_button := \
	func() -> void: play_note(preview_note, preview_waveform)

@onready var amy: Amy = _init_amy()


func _init_amy() -> Amy:
	var newAmy := Amy.new()
	newAmy.name = "Amy"
	self.add_child(newAmy)
	return newAmy


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if Input.is_action_just_pressed("Hit Note"):
		play_note(Note.new(Note.Notes.A, 4, 1))
	if Input.is_action_just_pressed("ui_up"):
		play_note(Note.new(Note.Notes.A, 5, 1))
	if Input.is_action_just_pressed("ui_down"):
		play_note(Note.new(Note.Notes.A, 3, 1))


func play_sequence(sequence: NoteSequence) -> void:
	sequence_played.emit(sequence)
	for note: Note in sequence.get_notes():
		if note: 
			await play_note(note, sequence.waveform)
	sequence_stopped.emit(sequence)


func play_note(note: Note, waveform := NoteSequence.Waves.SINE) -> void:
	# ensure that the oscillator actually exists
	if not amy: _init_amy()
	# play note
	amy.send({"osc": 0, "wave": waveform, "freq": note.get_frequency(), "vel": 1})
	note_played.emit(note)
	# wait for it to "finish" (thank you Xander)
	await get_tree().create_timer(note.sustain).timeout
	# stop note
	amy.send({"osc": 0, "vel": 0})
	note_stopped.emit(note)


func _calc_frequency(note: int, octave: int) -> float:
	return (starting_frequency * pow(2, octave)) * pow(2, note/12.0)
