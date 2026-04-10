extends Panel

@onready var mpvalue: Label = $MPValue



func _on_battle_menu_navigation_mana_changed(player_who_lost_mana: Player) -> void:
    if player_who_lost_mana.is_in_group("second player"):
        mpvalue.text = "MP: " + str(player_who_lost_mana.health) + "/" + str(player_who_lost_mana.max_hp)
