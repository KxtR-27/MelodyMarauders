class_name AmyWrapper 
extends Node


signal note_played
signal note_stopped

enum Notes {
				C4,		C_SHARP4,
	D_FLAT4,	D4,		D_SHARP4,
	E_FLAT4,	E4,
				F4,		F_SHARP4,
	G_FLAT4,	G4,		G_SHARP4,
	A_FLAT4,	A4,		A_SHARP4,
	B_FLAT4,	B4,
}

@onready var amy: Amy = _init_amy()
@onready var timer: Timer = $AmyTimer


func _init_amy() -> Amy:
	var newAmy := Amy.new()
	newAmy.name = "Amy"
	self.add_child(newAmy)
	return newAmy


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Hit Note"):
		play_note(440, 1)
	if Input.is_action_just_pressed("ui_up"):
		play_note(880, 0.5)
	if Input.is_action_just_pressed("ui_down"):
		play_note(220, 2)


func _on_amy_timer_timeout() -> void:
	stop_note()


func play_note(frequency: float, sustain: float) -> void:
	amy.send({"osc": 0, "wave": Amy.SINE, "freq": frequency, "vel": 1})
	timer.start(sustain)
	note_played.emit()


func stop_note() -> void:
	amy.send({"osc": 0, "vel": 0})
	note_stopped.emit()
