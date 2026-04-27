@tool
class_name SfxManagerMusicplayer
extends AudioStreamPlayer


@export_enum("Intro", "Loop", "End") var loop_segment: String = "Intro":
	set(segment):
		loop_segment = segment
		match (segment):
			"Intro": self.stream = loop_intro
			"Loop": self.stream = loop_loop
			"End": self.stream = loop_end

@export_range(-80.0, 1.0, 0.001, "suffix:dB") var loud_volume: float = 0.0
@export_range(-80.0, 1.0, 0.001, "suffix:dB") var quiet_volume: float = -18.0

@export var loop_intro: AudioStream
@export var loop_loop: AudioStream
@export var loop_end: AudioStream

var _should_end := false
var _should_be_quiet := false


func _on_finished() -> void:
	if loop_segment == "Intro":
		loop_segment = "Loop"
		self.play()
	elif loop_segment == "Loop":
		if _should_end:
			loop_segment = "End"
		self.play()


func end_after_this_loop() -> void: 
	_should_end = true


func end_immediately() -> void: 
	_should_end = true
	loop_segment = "End"
	self.play()


func quiet() -> void:
	_should_be_quiet = true
	_adjust_volume()


func loud() -> void:
	_should_be_quiet = false
	_adjust_volume()


func _adjust_volume() -> void:
	self.volume_db = quiet_volume if _should_be_quiet else loud_volume
