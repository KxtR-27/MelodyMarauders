class_name PressableGlyph
extends TextureRect


@export var unpressed_texture: Texture2D
@export var pressed_texture: Texture2D
@export var press_action: StringName


func _process(_delta: float) -> void:
	if Input.is_action_pressed(press_action):
		self.texture = pressed_texture
	else:
		self.texture = unpressed_texture
