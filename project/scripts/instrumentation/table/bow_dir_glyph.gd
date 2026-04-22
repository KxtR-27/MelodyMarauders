extends TextureRect

@export var down_unpressed: Texture2D
@export var down_pressed: Texture2D
@export var up_unpressed: Texture2D
@export var up_pressed: Texture2D
@export var seconds_between_frames: float = 0.5
@export var next_bow_dir_is_down: bool = true
@export var isUnpressed: bool = true
@export var needsAdjustment: bool = false

var accumulated_seconds: float = 0

@onready var violin: Violin = get_parent().get_parent().get_parent().get_parent()

func _process(delta: float) -> void:
	next_bow_dir_is_down = violin.last_bow_dir_was_up
	accumulated_seconds += delta
	
	while (accumulated_seconds > seconds_between_frames):
		accumulated_seconds -= seconds_between_frames
		isUnpressed = not isUnpressed
	
	if (next_bow_dir_is_down):
		if isUnpressed:
			self.texture = down_unpressed
		else: # if is pressed
			self.texture = down_pressed
	else: # if next bow dir is up
		if isUnpressed:
			self.texture = up_unpressed
		else: # if is pressed
			self.texture = up_pressed
	
	if needsAdjustment and isUnpressed:
		if next_bow_dir_is_down:
			size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		else: # if next bow dir is up
			size_flags_vertical = Control.SIZE_SHRINK_END
	else: # could need adjustment but is unpressed
		size_flags_vertical = Control.SIZE_FILL
