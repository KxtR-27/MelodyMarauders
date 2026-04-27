class_name Player
extends Sprite2D


## how strong attacks hit
@export var strength: int = 0
## reduces how much damage players take from attacks
@export var defense: int = 0
## resource to use special moves
@export var mana: int = 0
## determines how much damage players take from attacks
@export var health: int = 0
## the moves the player has at their disposal
@export var moves: Array[move_attack]

@onready var max_hp: int = health
@onready var max_mp: int = mana
var damage_bonus: int = 0

signal health_changed(player: Player)

func heal(amount: int) -> void:
	health = min(health + amount, max_hp)
	health_changed.emit(self)


func take_damage(amount: int) -> void:
	#var accuracy: float = await PlayerAttack.new()._use_sequencer()
	var accuracy : float = 0.5
	var final_damage: int = max(amount - (defense * accuracy), 0)
	health = max(health - final_damage, 0)
	health_changed.emit(self)
