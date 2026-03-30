extends Node2D


@onready var amy: Amy = _init_amy()
@onready var timer: Timer = $AmyTimer


func _init_amy() -> Amy:
	var newAmy := Amy.new()
	self.add_child(newAmy)
	return newAmy


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Hit Note"):
		amy.send({"osc": 0, "wave": Amy.SINE, "freq": 440, "vel": 1})
		timer.start()


func _on_amy_timer_timeout() -> void:
	amy.send({"osc": 0, "vel": 0})
