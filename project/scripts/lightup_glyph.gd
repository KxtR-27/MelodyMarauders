class_name LightupGlyph
extends PressableGlyph

const _unhighlighted_opacity := 0.5

@export var input_action: StringName
@export var additional_actions: Array[StringName]
@export_enum("Hold", "Toggle", "RadioToggle") var mode: String = "Hold"

@export var active := false


#func _ready() -> void:
	#self.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	#self.size_flags_horizontal = Control.SIZE_SHRINK_CENTER


func _process(_delta: float) -> void:
	super._process(_delta)
	
	var positive_actions: Array
	var negative_actions: Array
	
	# set positive and negative groups
	match mode:
		"Hold", "Toggle":
			positive_actions = [input_action] + additional_actions
		"RadioToggle":
			positive_actions = [input_action]
			negative_actions = additional_actions
	
	# enact them
	for action: StringName in positive_actions:
		if not action: 
			break
		
		match mode:
			"Hold": 
				if Input.is_action_pressed(action):
					active = true
					continue
				else:
					active = false
			"Toggle":
				if Input.is_action_just_pressed(action):
					active = not active
			"RadioToggle":
				if Input.is_action_just_pressed(action):
					active = true
				else:
					for neg_action: StringName in negative_actions:
						if Input.is_action_just_pressed(neg_action):
							active = false
							continue
	
	self.modulate.a = _unhighlighted_opacity if not active else 1.0
