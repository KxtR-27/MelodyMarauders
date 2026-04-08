extends Label



func _on_enemy_enemy_took_damage(current_health: int) -> void:
	self.text = "Health: " + str(current_health) + "/100"
