extends State
class_name PlayerAttack


static var sequencer_scene: PackedScene = preload("res://components/scrolling_notes_spawner/scrolling_staff_generator.tscn")

static var song_scene: Song = preload("res://resources/hot cross buns.tres")

@export var batNavMenu: BattleNavMenu

var can_spawn_minigame : bool = true

signal boss_hurt

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
		var results_screen: PackedScene = load("res://components/result_screen.tscn")
		var new_results: ResultsScreen = results_screen.instantiate()
		get_tree().current_scene.add_child(new_results)
		new_results.results_label.text = "You lose!"
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

	if batNavMenu.note_list.visible and Input.is_action_just_pressed("ui_accept") and can_spawn_minigame:
		can_spawn_minigame = false
		batNavMenu.can_interact = false
		
		print("the mana of move used is " + str(batNavMenu.currently_selected_move.mana_value))
		print("The mana the currently selected player has is" + str(batNavMenu.currently_selected_player.mana))
		
		if (batNavMenu.currently_selected_move.mana_value > batNavMenu.currently_selected_player.mana):
			return
			
		batNavMenu.currently_selected_player.mana -= batNavMenu.currently_selected_move.mana_value
		batNavMenu.mana_changed.emit(batNavMenu.currently_selected_player)
		
		var accuracy: float = await _use_sequencer()
		var move := batNavMenu.currently_selected_move
		var player := batNavMenu.currently_selected_player
		
		#batNavMenu.currently_selected_player.heal(batNavMenu.currently_selected_move.HEAL * accuracy)
		#var damage_dealt_to_enemy := batNavMenu.currently_selected_move.DMG * accuracy
		#batNavMenu.attack_enemy.emit(damage_dealt_to_enemy)
		
		if move.HEAL > 0:
			var heal_amount := int(move.HEAL * accuracy)
			player.heal(heal_amount)

		if move.BUFF_DAMAGE > 0:
			var buff_amount: int = max(1, int(move.BUFF_DAMAGE * accuracy))
			for p: Player in [batNavMenu.player1, batNavMenu.player2]:
				p.damage_bonus += buff_amount

		var damage_dealt_to_enemy : float= (move.DMG + player.damage_bonus) * accuracy
		batNavMenu.attack_enemy.emit(damage_dealt_to_enemy)
		
		# globals that are not scripts are weakly typed.
		# autocomplete knows that SfxManager is typed,
		#  but GDScript's linter does not.
		@warning_ignore_start("unsafe_method_access")
		var did_damage :float = damage_dealt_to_enemy > 0
		if did_damage:
			SfxManager.play_hit_sound()
			boss_hurt.emit()
		else:
			SfxManager.play_defend_sound()
		@warning_ignore_restore("unsafe_method_access")
		
		batNavMenu.note_list.visible = false
		
		can_spawn_minigame = true
		batNavMenu.can_interact = true
		
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
