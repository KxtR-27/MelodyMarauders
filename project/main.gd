class_name Main
extends Node2D


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


# Notes:
#
# win/loss triggers
# -> Player win condition in `enemy.gd#_on_battle_menu_navigation_attack_enemy()`
# -> Player loss condition in `player_attack.gd#Enter()`
#
# Sequencer does not work so `player_attack.gd#_use_sequence()` returns hardcoded value
# -> this applies to player attacks AND player defense
