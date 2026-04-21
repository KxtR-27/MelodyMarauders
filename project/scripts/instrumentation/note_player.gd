@tool
class_name NotePlayer 
extends Node


## emits when a note starts playing
signal note_played(note: Note)
## emits when a note stops playing
signal note_stopped(note: Note)

enum Waves {
	SINE = 0, 
	PULSE = 1,
	SAW_DOWN = 2,
	SAW_UP = 3,
	TRIANGLE = 4,
	NOISE = 5,
}

const starting_frequency := 16.35 # C0


@export_group("Note Preview")
@export var preview_waveform: Waves = Waves.SINE
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


func play_note(note: Note, waveform := Waves.SINE, should_sustain: bool = false) -> void:
	# ensure that the oscillator actually exists
	if not amy: _init_amy()
	
	# good lord the saw waves are loud
	var lower_volume := waveform == Waves.SAW_DOWN or waveform == Waves.SAW_UP
	var velocity := 1.0 if not lower_volume else 0.5
	# play note
	amy.send({"osc": 0, "wave": waveform, "freq": note.get_frequency(), "vel": velocity})
	note_played.emit(note)
	
	if not should_sustain:
		# wait for it to "finish" (thank you Xander)
		await get_tree().create_timer(note.sustain).timeout
		stop_note(note)
	else:
		print("Note %s is being sustained! You will have to stop it manually!" % note)


func stop_note(note: Note = null) -> void:
	amy.send({"osc": 0, "vel": 0})
	note_stopped.emit(note)


func play_extra(note: Note, waveform := Waves.SINE) -> void:
	# ensure that the oscillator actually exists
	if not amy: _init_amy()
	
	# use the note frequency but off pitch
	var baseFrequency := note.get_frequency()
	var nastyFrequency := baseFrequency + randf_range(-100, 100)
	
	# play note
	amy.send({"osc": 0, "wave": waveform, "freq": nastyFrequency, "vel": 1})
	note_played.emit(note)
	# wait for it to "finish" (thank you Xander)
	await get_tree().create_timer(0.05).timeout
	# stop note
	amy.send({"osc": 0, "vel": 0})
	note_stopped.emit(note)


func _calc_frequency(note: int, octave: int) -> float:
	return (starting_frequency * pow(2, octave)) * pow(2, note/12.0)
