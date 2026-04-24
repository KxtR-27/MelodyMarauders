extends State
class_name BossAttack

@export var enemy: Enemy
@export var batNavMenu: BattleNavMenu

const DEFENSE_MINIGAME = preload("res://components/battle_menu/defense_minigame.tscn")

func Enter() -> void:
	batNavMenu.can_interact = false
	
	print("Boss turn!")
	var defense_minigame_node : DefenseMinigame = DEFENSE_MINIGAME.instantiate() 
	get_tree().current_scene.add_child(defense_minigame_node)
	
	var accuracy: float = await defense_minigame_node.answer_submitted
	
	defense_minigame_node.queue_free()
	
	var damage : int = enemy.generate_attack()
	var damage_dealt_to_player : int = int(damage * (1 - accuracy))
	enemy.attack_player(damage_dealt_to_player)
	
	# globals that are not scripts are weakly typed.
	# autocomplete knows that SfxManager is typed,
	#  but GDScript's linter does not.
	@warning_ignore_start("unsafe_method_access")
	var did_damage := damage_dealt_to_player > 0
	if did_damage:
		SfxManager.play_hit_sound()
	else:
		SfxManager.play_defend_sound()
	@warning_ignore_restore("unsafe_method_access")
	
	await get_tree().create_timer(0.5).timeout
	Transitioned.emit(self, "playerattack")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass


func Physics_Update(_delta: float) -> void:
	pass
