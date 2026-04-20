class_name ScrollingStaffGenerator
extends Node2D

@export var debug : bool = false
@onready var staff_minigame : StaffMinigame = $StaffMinigame
@onready var main_control : Control = $MainControl
@onready var note_pipe_container : NotePipeContainer = $MainControl/NotePipeContainer

signal song_finished(accuracy : float)

func _ready() -> void:
	if debug:
		$MainControl/LoadSongHBox.visible = true
		$MainControl/ScoreLabel.visible = true
		$MainControl/PlayButton.visible = true


func play_song(song : Song) -> void:
	staff_minigame.reset()
	staff_minigame._load_song(song)
	await get_tree().create_timer(0.5).timeout
	staff_minigame._play_song()
	
	main_control.visible = true


func _on_load_button_button_down() -> void:
	var file_dialog : FileDialog = $FileDialog
	file_dialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	var path_string_split : Array = path.split("/")
	var file_name : String = path_string_split[(path_string_split.size() - 1)]
	var label : Label = $MainControl/LoadSongHBox/CurrentSongLabel
	label.text = "Current song: " + file_name
	var loaded_song : Song = ResourceLoader.load(path, "Song")
	staff_minigame._load_song(loaded_song)


func _on_play_button_button_down() -> void:
	staff_minigame._play_song()


func _on_staff_minigame_score_tallied(hit_percentage: float) -> void:
	song_finished.emit(hit_percentage)
	main_control.visible = false


func _on_staff_minigame_note_pipes_requested(scroll_speed : int) -> void:
	for child in $MainControl/NotePipeContainer.get_children():
		child.queue_free()
	
	note_pipe_container.create_pipes(scroll_speed)
	print("signal to create pipes received")


func _on_staff_minigame_spawn_note_requested(note : SequencerNote, speed : int, tempo : int) -> void:
	var new_note : ScrollingNote = note_pipe_container.spawn_note(note, speed, tempo)
	new_note.pitch_name = note.pitch_name
	new_note.octave = note.octave
	
	if new_note.pitch_name == "C" and note.octave == 4:
		new_note.get_node("LedgerLine").visible = true
	elif new_note.pitch_name == "A" and note.octave == 5:
		new_note.get_node("LedgerLine").visible = true
