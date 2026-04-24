class_name SfxManagerGlobal
extends Node


enum SFX {
	DEFEND,
	HIT,
	MISS,
}

static var _sfx_map: Dictionary[SFX, AudioStream] = {
	SFX.DEFEND: preload("res://assets/audio/defend.sfxr"),
	SFX.HIT: preload("res://assets/audio/hit.sfxr"),
	SFX.MISS: preload("res://assets/audio/miss.sfxr"),
}

@onready var music_player: AudioStreamPlayer = $MusicPlayer


func play_sound(sound: SFX) -> void:
	self.add_child(OneshotSFXPlayer.new(_sfx_map[sound]))


func play_defend_sound() -> void: play_sound(SFX.DEFEND)
func play_hit_sound() -> void: play_sound(SFX.HIT)
func play_miss_sound() -> void: play_sound(SFX.MISS)


class OneshotSFXPlayer extends AudioStreamPlayer:
	func _init(sound: AudioStream) -> void:
		self.stream = sound
		self.autoplay = true
		self.finished.connect(func() -> void: self.queue_free())
