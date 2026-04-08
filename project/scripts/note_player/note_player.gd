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
## emits when a given node does so manually
@warning_ignore("unused_signal")
signal play_next_note_in_await(type: PlayAwaitTypes)

## emits when player hits a note correctly
signal hit
## emits when player completely misses a note
signal skip
## emits when player misses but hits incorrectly
signal extra

enum PlayAwaitTypes {
	HIT,	# player hits the note correctly
	SKIP,	# player completely misses the note
	EXTRA	# player misses but hits incorrectly
}

const starting_frequency := 16.35 # C0

@export_group("Note Sequence")
@export var note_sequence: NoteSequence = NoteSequence.new()
@export_enum("Automatic", "Await") var mode: int = 0
@export_tool_button("Play Sequence", "AudioStreamWAV") var play_sequence_button := \
	func() -> void: 
		print("playing sequence [%s] in editor" % note_sequence)
		play_sequence_automatically(note_sequence)


@export_group("Note Preview")
@export var preview_waveform: NoteSequence.Waves = NoteSequence.Waves.SINE
@export var preview_note: Note = Note.new()
@export_tool_button("Play Preview", "AudioListener2D") var preview_button := \
	func() -> void: 
		print("playing note preview in editor")
		play_note(preview_note, preview_waveform)

@export_category("Hit this button in the editor. Idk why this happens.")
@export_tool_button("Reset Synthesizer", "Reload") var reset_button: Callable = \
	func() -> void:
		if amy: amy.free()
		amy = _init_amy()

@onready var amy: Amy = _init_amy()


func _init_amy() -> Amy:
	var newAmy := Amy.new()
	newAmy.name = "Amy"
	self.add_child(newAmy)
	return newAmy


func _ready() -> void:
	if !amy: amy = _init_amy()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return


func play_sequence(sequence: NoteSequence) -> void:
	if mode == 0: play_sequence_automatically(sequence) 
	else: play_sequence_awaiting(sequence)


func play_sequence_automatically(sequence: NoteSequence) -> void:
	sequence_played.emit(sequence)
	for note: Note in sequence.get_notes():
		if note:
			await play_note(note, sequence.waveform)
	sequence_stopped.emit(sequence)


func play_sequence_awaiting(sequence: NoteSequence) -> void:
	sequence_played.emit()
	print("start")
	for note: Note in sequence.get_notes():
		var play_type: PlayAwaitTypes = await play_next_note_in_await
		while play_type == PlayAwaitTypes.EXTRA:
			play_extra(note, sequence.waveform)
			extra.emit()
			print("extra")
			play_type = await play_next_note_in_await
		if play_type == PlayAwaitTypes.HIT:
			await play_note(note, sequence.waveform)
			hit.emit()
			print("hit")
		elif play_type == PlayAwaitTypes.SKIP:
			skip.emit()
			print("skip")
	print("end")


func play_note(note: Note, waveform := NoteSequence.Waves.SINE) -> void:
	if not note: return
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


func play_extra(note: Note, waveform := NoteSequence.Waves.SINE) -> void:
	# ensure that the oscillator actually exists
	if not amy: _init_amy()
	# play note
	var baseFrequency := note.get_frequency()
	var nastyFrequency := baseFrequency + randf_range(-100, 100)
	amy.send({"osc": 0, "wave": waveform, "freq": nastyFrequency, "vel": 1})
	note_played.emit(note)
	# wait for it to "finish" (thank you Xander)
	await get_tree().create_timer(0.05).timeout
	# stop note
	amy.send({"osc": 0, "vel": 0})
	note_stopped.emit(note)


func _calc_frequency(note: int, octave: int) -> float:
	return (starting_frequency * pow(2, octave)) * pow(2, note/12.0)
