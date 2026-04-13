extends Node2D

var defense_scene = preload("res://components/arpeggio_frame.tscn")
var defense_instance = null


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_defense"):
		toggle_defense()
		
		
		
func toggle_defense() -> void:
	if defense_instance == null:
		open_defense()
	else:
		close_defense()
# Called when the node enters the scene tree for the first time.

func open_defense() -> void:
	defense_instance = defense_scene.instantiate()
	defense_instance.close_defense.connect(close_defense)
	$".".add_child(defense_instance)
	
func close_defense() -> void:
	if defense_instance:
		defense_instance.queue_free()
		defense_instance = null
   
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
