class_name Main
extends Node2D


@export var LeftInstrumentLabel: Label
@export var RightInstrumentLabel: Label

var leftInstrumentValue := 0
var rightInstrumentValue := 0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Left Instrument Down"):
		leftInstrumentValue -= 1
	elif Input.is_action_just_pressed("Left Instrument Up"):
		leftInstrumentValue += 1
	elif Input.is_action_just_pressed("Right Instrument Down"):
		rightInstrumentValue -= 1
	elif Input.is_action_just_pressed("Right Instrument Up"):
		rightInstrumentValue += 1
	
	LeftInstrumentLabel.text = "%d" % leftInstrumentValue
	RightInstrumentLabel.text = "%d" % rightInstrumentValue
