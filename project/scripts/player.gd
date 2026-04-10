extends Sprite2D
class_name Player
## how strong attacks hit
@export var strength: int = 0
## reduces how much damage players take from attacks
@export var defense: int = 0
## resource to use special moves
@export var mana: int = 0
## determines how much damage players take from attacks
@export var health: int = 0
## the moves the player has at their disposal
@export var moves: Dictionary[String, move_attack]

@onready var max_hp: int = health
@onready var max_mp: int = mana