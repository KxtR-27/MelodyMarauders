extends Control

# amount of notes players need to guess (1? for now)
# accuracy variable same as used in attack script - get from there

#var noteGuessAmount = 1
#var rightNote: bool = false 
var enemyAttackPoints: number = 10;

signal close_defense

func _input(event):
	if event.is_action_pressed("close_defense"):
		emit_signal("close_defense")

#note range of collision has to take in not hit or hit value from master cursor
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
