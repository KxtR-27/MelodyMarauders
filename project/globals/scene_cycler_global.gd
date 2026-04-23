#class_name SceneCyclerGlobal
extends Node

@export var scenes: Array[PackedScene] = [
	preload("res://main.tscn"),
	preload("res://components/instrumentation/violin.tscn"),
	preload("res://components/instrumentation/trumpet.tscn"),
]

@export var allowed_to_cycle: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("cycle_scene") and allowed_to_cycle:
		_cycle_scenes()

func _cycle_scenes() -> void:
	scenes.append(scenes.pop_front())
	get_tree().change_scene_to_packed(scenes[0])
	await get_tree().scene_changed
	print("[SCENE CYCLED] Changed Scene to `%s`" % get_tree().current_scene.name)
