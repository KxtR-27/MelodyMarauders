extends Panel

## this represents which player this bar corresponds to
@export var bar_owner: Player

@onready var mpvalue: Label = $MPValue

func _ready() -> void:
	# allows the text to match the acutal mana values that the players have
	mpvalue.text = "MP: " + str(bar_owner.mana) + "/" + str(bar_owner.mana)


# a function that allows for the mana to be change when players use mana
func _on_battle_menu_navigation_mana_changed(player_who_lost_mana: Player) -> void:
	print("I receieved this signal")
	if bar_owner == player_who_lost_mana:
		mpvalue.text = "MP: " + str(player_who_lost_mana.mana) + "/" + str(player_who_lost_mana.max_mp)
