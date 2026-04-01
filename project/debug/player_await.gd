extends Node

signal next_note

@onready var player: NotePlayer = $NotePlayer

func _ready() -> void:
	player.signalToAwaitBetweenNotes = next_note

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Hit Note"):
		next_note.emit()
