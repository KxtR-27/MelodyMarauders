class_name AmyManager extends Node

const STARTING_PITCH_OFFSET : int = 24
const STARTING_PATCH_OFFSET : int = 1024

var playback_start_time_ms : int = 0

var amy : Amy
var patch_settings : Dictionary = {
	"Sine" : {
		"oscs" : {
			0 : Amy.SINE
		},
		"num_voices" : 4,
	},
	"Triangle" : {
		"oscs" : {
			0 : Amy.TRIANGLE
		},
		"num_voices" : 4,
	},
	"BassDrum" : {
		"oscs" : {
			0 : Amy.PCM
		},
		"num_voices" : 1,
		"preset" : 1
	},
	"Snare" : {
		"oscs" : {
			0 : Amy.PCM
		},
		"num_voices" : 1,
		"preset" : 2
	},
	"Clap" : {
		"oscs" : {
			0 : Amy.PCM
		},
		"num_voices" : 1,
		"preset" : 9
	},
	"ClosedHat" : {
		"oscs" : {
			0 : Amy.PCM
		},
		"num_voices" : 1,
		"preset" : 6
	},
	"OpenHat" : {
		"oscs" : {
			0 : Amy.PCM
		},
		"num_voices" : 1,
		"preset" : 7
	},
	"Cowbell" : {
		"oscs" : {
			0 : Amy.PCM
		},
		"num_voices" : 1,
		"preset" : 10
	}
}

var pitch_offsets : Dictionary = {
	"C" : 0,
	"D" : 2,
	"E" : 4,
	"F" : 5,
	"G" : 7,
	"A" : 9,
	"B" : 11
}

var instrument_ids : Dictionary = {}

func _ready() -> void:
	amy = Amy.new()
	add_child(amy)
	await get_tree().process_frame
	amy.send({"reset" : 1})
	
	var current_patch_offset : int = STARTING_PATCH_OFFSET
	for patch : String in patch_settings.keys():
		var current_patch_settings : Dictionary = patch_settings[patch]
		var oscillators : Dictionary = current_patch_settings["oscs"]
		
		for osc : int in oscillators.keys():
			if oscillators[osc] != Amy.PCM:
				amy.send({
					"patch" : current_patch_offset,
					"osc" : osc,
					"wave" : oscillators[osc],
				})
			else:
				amy.send({
					"patch" : current_patch_offset,
					"osc" : osc,
					"wave" : oscillators[osc],
					"preset" : current_patch_settings["preset"]
				})
		
		var current_id : int = instrument_ids.size()
		var num_voices : int = current_patch_settings["num_voices"]
		amy.send({
			"synth" : current_id, 
			"num_voices" : num_voices, 
			"patch" : current_patch_offset}
		)
		
		instrument_ids[patch] = current_id
		current_patch_offset += 1

func play_note(note : SequencerNote, tempo : int, added_delay_ms : int) -> void:
	#obtain midi note for the note's pitch
	var midi_note : int = pitch_offsets[note.pitch_name] + STARTING_PITCH_OFFSET
	midi_note += (note.octave * 12)
	match note.accidental:
		"sharp":
			midi_note += 1
		"flat":
			midi_note -= 1
		"natural":
			pass
	
	#obtain start delay and end time, send both notes at once
	var pulse : float = 60.0/tempo
	
	var sustain_sec : float = note.length * pulse 
	var measure_added_delay: int = int((pulse * 4) * (note.measure - 1)) * 1000
	var start_delay_sec : float = ((note.beat - 1) * pulse)
	var start_delay_ms : int = \
	added_delay_ms + playback_start_time_ms + measure_added_delay + int(start_delay_sec * 1000.0) #amy calculates delay in ms
	var end_time_ms : int = \
	added_delay_ms + playback_start_time_ms + measure_added_delay + int((start_delay_sec + sustain_sec) * 1000.0)
	amy.send({
		"synth" : instrument_ids[note.instrument], 
		"note" : midi_note, 
		"vel" : 4, 
		"time" : start_delay_ms
	})
	
	amy.send({
		"synth" : instrument_ids[note.instrument], 
		"note" : midi_note, 
		"vel" : 0, 
		"time" : end_time_ms
	})


func play_notes_in_array(array : Array, tempo : int, added_delay_ms : int) -> void:
	for note : SequencerNote in array:
		play_note(note, tempo, added_delay_ms)


func start_sustain(instrument : String, midi_note : int) -> void:
	amy.send({
		"synth" : instrument_ids[instrument],
		"note" : midi_note,
		"vel" : 4
	})


func stop_sustain(instrument : String, midi_note : int) -> void:
	amy.send({
		"synth" : instrument_ids[instrument],
		"note" : midi_note,
		"vel" : 0
	})
