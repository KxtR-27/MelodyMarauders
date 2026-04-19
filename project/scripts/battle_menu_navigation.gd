extends Control
class_name BattleNavMenu


@warning_ignore_start("unused_signal")
signal attack_enemy(damage: float)
signal mana_changed(player_who_lost_mana: Player)
@warning_ignore_restore("unused_signal")

@export var midnight_sonata: Button
@export var concierto_for_triangle: Button
@export var in_bleak_midwinter: Button
@export var move_description: Label
@export var dmg: Label
@export var mp: Label
@export var player1: Player
@export var player2: Player
@export var move_list: Dictionary[String, move_attack]
@export var enemy: Enemy
@export var note_list: Panel
@export var action_list: HBoxContainer
@export var note: Button

var currently_selected_move: move_attack = null
var can_interact: bool = false

@onready var note_selection: VBoxContainer = $Note_list_panel/Note_selection
var currently_selected_player: Player = null


func _ready() -> void:
	currently_selected_player = player1
	note.grab_focus.call_deferred()
	note.pressed.connect(_on_button_pressed)
	get_viewport().gui_focus_changed.connect(_on_gui_focus_changed)
	action_list.visible = true
	note_list.visible = false
	enemy.players = [player1, player2]


func _on_button_pressed() -> void:
	if !can_interact:
		return
		
	for child in note_selection.get_children():
		child.free()
		
	for move: move_attack in currently_selected_player.moves:
			var move_button: PackedScene = preload("res://scenes/move_button.tscn")
			var move_instance: MoveButton = move_button.instantiate()
			move_instance.move_data = move
			move_instance.text = move.NAME
			note_selection.add_child(move_instance)
			
	action_list.visible = false
	note_list.visible = true
	
	var first_child: MoveButton = note_selection.get_child(0);
	var last_child: MoveButton = note_selection.get_child(-1);
	
	first_child.focus_neighbor_top = last_child.get_path()
	last_child.focus_neighbor_bottom = first_child.get_path()
	first_child.grab_focus.call_deferred()


func _on_gui_focus_changed(object: Object) -> void:
	if !can_interact:
		return
		
	if object is MoveButton:
		currently_selected_move = (object as MoveButton).move_data
		move_description.text = currently_selected_move.move_description
		dmg.text = str(currently_selected_move.DMG)
		mp.text = str(currently_selected_move.mana_value)


func reset_battle_menu() -> void:
	action_list.visible = true
	note_list.visible = false
	note.grab_focus.call_deferred()


func _on_run_pressed() -> void:
	#This is just to test boss damage is working 
	var damage : int = enemy.generate_attack()
	enemy.attack_player(damage)
