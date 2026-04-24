extends State
class_name PlayerAttack


static var sequencer_scene: PackedScene = preload("res://components/scrolling_notes_spawner/scrolling_staff_generator.tscn")

static var song_scene: Song = preload("res://resources/hot cross buns.tres")

@export var batNavMenu: BattleNavMenu


func Enter() -> void:
	print("I am in the PlayerAttack STate right now")
	batNavMenu.visible = true
	batNavMenu.reset_battle_menu()
	batNavMenu.can_interact = true
	batNavMenu.currently_selected_player = batNavMenu.player1
	
	var player_1_alive := batNavMenu.player1.health > 0
	var player_2_alive := batNavMenu.player2.health > 0
	
	if not player_1_alive and not player_2_alive:
		# go to game over scene
		print("player loses!")
		Exit()
		
	
	if batNavMenu.currently_selected_player == batNavMenu.player1 and not player_1_alive:
		batNavMenu.currently_selected_player = batNavMenu.player2
	elif batNavMenu.currently_selected_player == batNavMenu.player2 and not player_2_alive:
		self.Transitioned.emit(self, "BossAttack")
		
		
	if !batNavMenu.rest_used.is_connected(_on_rest_used):
		batNavMenu.rest_used.connect(_on_rest_used)
	


func Exit() -> void:
	batNavMenu.visible = false
	batNavMenu.currently_selected_player = null


func Update(_delta: float) -> void:
	if batNavMenu.note_list.visible and Input.is_action_just_pressed("ui_cancel"):
		batNavMenu.currently_selected_player = batNavMenu.player1
		batNavMenu.reset_battle_menu()
		batNavMenu.note_list.visible = false

	if batNavMenu.note_list.visible and Input.is_action_just_pressed("ui_accept"):
		print("the mana of move used is " + str(batNavMenu.currently_selected_move.mana_value))
		print("The mana the currently selected player has is" + str(batNavMenu.currently_selected_player.mana))
		
		if (batNavMenu.currently_selected_move.mana_value > batNavMenu.currently_selected_player.mana):
			return
			
		batNavMenu.currently_selected_player.mana -= batNavMenu.currently_selected_move.mana_value
		batNavMenu.mana_changed.emit(batNavMenu.currently_selected_player)
		
		var accuracy: float = await _use_sequencer()
		#var accuracy: float = _use_sequencer()
		
		batNavMenu.attack_enemy.emit(batNavMenu.currently_selected_move.DMG * accuracy)
		batNavMenu.note_list.visible = false
		
		if batNavMenu.currently_selected_player == batNavMenu.player1:
			batNavMenu.currently_selected_player = batNavMenu.player2
			batNavMenu.reset_battle_menu()
			return
		elif batNavMenu.currently_selected_player == batNavMenu.player2:
			self.Transitioned.emit(self, "BossAttack")


func Physics_Update(_delta: float) -> void:
	pass
	
func _on_rest_used(player: Player) -> void:
	print("rest used by ", player)
	player.mana = min(player.mana + 5, player.max_mp)
	print(player.mana)
	batNavMenu.mana_changed.emit(player)
	
	if player == batNavMenu.player1:
		batNavMenu.currently_selected_player = batNavMenu.player2
		batNavMenu.reset_battle_menu()
	else:
		Transitioned.emit(self, "BossAttack")


func _use_sequencer() -> float:
	batNavMenu.player_1_hp_mp.visible = false
	batNavMenu.player_2_hp_mp.visible = false
	batNavMenu.player1.visible = false
	batNavMenu.player2.visible = false
	batNavMenu.enemy.visible = false
	batNavMenu.visible = false
	
	var minigame_generator : ScrollingStaffGenerator = sequencer_scene.instantiate()
	get_tree().current_scene.add_child(minigame_generator)
	minigame_generator.visible = true
	minigame_generator.play_song(song_scene)
	var accuracy: float = await minigame_generator.song_finished
	
	minigame_generator.queue_free()
	
	batNavMenu.player_1_hp_mp.visible = true
	batNavMenu.player_2_hp_mp.visible = true
	batNavMenu.player1.visible = true
	batNavMenu.player2.visible = true
	batNavMenu.enemy.visible = true
	batNavMenu.visible = true
	
	return accuracy
	#return 1.00
