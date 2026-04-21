@tool
extends VBoxContainer

@export_enum(
	"trumpet_open_bottom", 
	"trumpet_open_left", 
	"trumpet_open_right", 
	"trumpet_open_top", 
) var embouchure: String = "trumpet_open_bottom"

@onready var trumpet: Trumpet = get_parent().get_parent().get_parent()
@onready var output_label: Label = $Output

func _process(_delta: float) -> void:
	output_label.text =  \
		trumpet.EMBOUCHURE_INPUT_MAP[embouchure] \
			.bend(trumpet.VALVE_BEND_MAP[trumpet.valve_combo]) \
				.to_string()
