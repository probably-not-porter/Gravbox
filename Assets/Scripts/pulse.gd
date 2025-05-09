extends Label
var fade_timer := 0.0  # running time

func _process(delta):
	fade_timer += delta
	var fade_speed := 2  # seconds per full cycle

	# Use sine wave to oscillate between 0.5 and 0.8
	var alpha := 0.75 + 0.25 * sin(fade_timer * TAU / fade_speed)
	
	# Apply alpha to modulate color
	self.modulate.a = alpha
