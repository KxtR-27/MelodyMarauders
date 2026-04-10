extends Node2D

var c_major_scale : Array = ["C", "D", "E", "F", "G", "A", "B", "CU"]

func _ready() -> void:
	for i in range(8):
		$SoundManager._play_hit_note("Sine", c_major_scale[i])
		await get_tree().create_timer(1.25).timeout
	
	await get_tree().create_timer(1.25).timeout
	
	for i in range(8):
		$SoundManager._play_missed_note("Sine", c_major_scale[i])
		await get_tree().create_timer(1.25).timeout
	
	await get_tree().create_timer(1.25).timeout
	
	for i in range(8):
		$SoundManager._play_hit_note("Sawtooth", c_major_scale[i])
		await get_tree().create_timer(1.25).timeout
	
	await get_tree().create_timer(1.25).timeout
	
	for i in range(8):
		$SoundManager._play_missed_note("Sawtooth", c_major_scale[i])
		await get_tree().create_timer(1.25).timeout
	
	await get_tree().create_timer(1.25).timeout
	
	# mario
	$SoundManager._play_hit_note("Sine", "A")
	await get_tree().create_timer(0.10).timeout
	$SoundManager._stop_note("Sine", "A")
	await get_tree().create_timer(0.05).timeout
	
	$SoundManager._play_hit_note("Sine", "A")
	await get_tree().create_timer(0.10).timeout
	$SoundManager._stop_note("Sine", "A")
	await get_tree().create_timer(0.2).timeout
	
	$SoundManager._play_hit_note("Sine", "A")
	await get_tree().create_timer(0.10).timeout
	$SoundManager._stop_note("Sine", "A")
	await get_tree().create_timer(0.2).timeout
	
	$SoundManager._play_hit_note("Sine", "F")
	await get_tree().create_timer(0.10).timeout
	$SoundManager._stop_note("Sine", "F")
	await get_tree().create_timer(0.05).timeout
	
	$SoundManager._play_hit_note("Sine", "A")
	await get_tree().create_timer(0.10).timeout
	$SoundManager._stop_note("Sine", "A")
	await get_tree().create_timer(0.2).timeout
	
	$SoundManager._play_hit_note("Sine", "CU")
	await get_tree().create_timer(0.30).timeout
	$SoundManager._stop_note("Sine", "CU")
	await get_tree().create_timer(0.3).timeout
	
	$SoundManager._play_hit_note("Sine", "C")
	await get_tree().create_timer(0.30).timeout
	$SoundManager._stop_note("Sine", "C")
	await get_tree().create_timer(0.3).timeout
