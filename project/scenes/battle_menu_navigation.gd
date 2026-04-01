extends Control

@onready var action_list: HBoxContainer = $Action_list
@onready var note: Button = $Action_list/Note
@onready var note_list: Panel = $Note_list_panel
@export var midnight_sonata: Button
@export var concierto_for_triangle: Button
@export var in_bleak_midwinter: Button
@export var move_description: Label
@export var dmg: Label
@export var mp: Label

func _ready() -> void:
	note.grab_focus.call_deferred()
	note.pressed.connect(_on_button_pressed)
	get_viewport().gui_focus_changed.connect(_on_gui_focus_changed)
	action_list.visible = true
	note_list.visible = false


func _process(_delta: float) -> void:
	if note_list.visible and Input.is_action_just_pressed("ui_cancel"):
		action_list.visible = true
		note_list.visible = false
		note.grab_focus.call_deferred()


func _on_button_pressed() -> void:
	action_list.visible = false
	note_list.visible = true
	midnight_sonata.grab_focus.call_deferred()

func _on_gui_focus_changed(object: Object) -> void:
	
	match object:
		midnight_sonata:
			move_description.text = "Damages all enemies. If played perfectly, inflicts sleep to 1 target"
			dmg.text = "3DMG"
			mp.text = "5MP"
		in_bleak_midwinter:
			move_description.text = "Damages all enemies. If perfectly played, freezes 1 target"
			dmg.text = "4DMG"
			mp.text = "4MP"
		concierto_for_triangle:
			move_description.text = "Player must hit one tricky note. If the tricky note is hit, stun 1 enemy"
			dmg.text = "10DMG"
			mp.text = "3MP"
