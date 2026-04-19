extends State
class_name BossAttack

@export var enemy: Enemy
@export var batNavMenu: BattleNavMenu

const DEFENSE_MINIGAME = preload("res://scenes/defense_minigame/defense_minigame.tscn")

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
	
	await get_tree().create_timer(0.5).timeout
	Transitioned.emit(self, "playerattack")


func Exit() -> void:
	pass


func Update(_delta: float) -> void:
	pass


func Physics_Update(_delta: float) -> void:
	pass
