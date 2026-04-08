class_name TrackContainer extends VBoxContainer

func get_track_by_instrument_name(instrument : String) -> SequencingTrack:
	var children : Array = get_children()
	for child in children:
		if child.instrument == instrument:
			return child
	
	return null
