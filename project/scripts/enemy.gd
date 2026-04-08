extends Sprite2D

signal enemy_took_damage(current_health: int)
@export var health: float = 100

func _on_battle_menu_navigation_attack_enemy(damage: float) -> void:
    health -= damage
    enemy_took_damage.emit(health)
    
