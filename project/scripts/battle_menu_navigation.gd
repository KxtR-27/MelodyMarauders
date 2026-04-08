extends Control

signal attack_enemy(damage: float) 

@onready var action_list: HBoxContainer = $Action_list
@onready var note: Button = $Action_list/Note
@onready var note_list: Panel = $Note_list_panel
@export var midnight_sonata: Button
@export var concierto_for_triangle: Button
@export var in_bleak_midwinter: Button
@export var move_description: Label
@export var dmg: Label
@export var mp: Label
var currently_selected_move: move_attack = null
@export var move_list: Dictionary[String, move_attack]




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

	if note_list.visible and Input.is_action_just_pressed("ui_accept"):
		print("I would be attacking right now")
		attack_enemy.emit(currently_selected_move.DMG)



func _on_button_pressed() -> void:
	action_list.visible = false
	note_list.visible = true
	midnight_sonata.grab_focus.call_deferred()

func _on_gui_focus_changed(object: Object) -> void:
	
	match object:
		midnight_sonata:
			currently_selected_move = move_list["midnight"]
		in_bleak_midwinter:
			currently_selected_move = move_list["winter"]
		concierto_for_triangle:
			currently_selected_move = move_list["triangle"]
		_:
			return
	
	move_description.text = currently_selected_move.move_description
	dmg.text = str(currently_selected_move.DMG)
	mp.text = str(currently_selected_move.mana_value)
