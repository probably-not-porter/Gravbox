extends Control

@export var initial_delay_seconds: float = 0.1 # Set this in the inspector
@export var fade_speed: float = 1.0 # How quickly the alpha changes
@export var wait_max: float = 100.0 # Max count for fade/action trigger

var _can_process_input: bool = false
var _time_elapsed: float = 0.0

var _quit_current_count: float = 99.0
var _restart_current_count: float = 99.0

func _ready() -> void:
	# Ensure labels exist before trying to access them
	if not has_node("QuitLabel"):
		push_warning("QuitLabel node not found!")
	if not has_node("RestartLabel"):
		push_warning("RestartLabel node not found!")

func _process(delta: float) -> void:
	if not _can_process_input:
		_time_elapsed += delta
		if _time_elapsed >= initial_delay_seconds:
			_can_process_input = true
		return # Exit early if not yet active
	else:
		# Handle ESC-to-quit
		_quit_current_count = _update_input_and_label(
			"quit",
			$QuitLabel,
			_quit_current_count, # Pass the current count
			func(): get_tree().current_scene.load_main_menu()
		)

		# Handle Space-to-reload
		_restart_current_count = _update_input_and_label(
			"restart",
			$RestartLabel,
			_restart_current_count, # Pass the current count
			func(): get_tree().current_scene.reload_level()
	)

# This function now takes 'current_count' as a parameter and returns the NEW count.
func _update_input_and_label(action_name: String, label_node: Label, current_count: float, on_max_action: Callable) -> float:
	var new_count = current_count # Work with a local copy

	if Input.is_action_pressed(action_name):
		new_count += fade_speed
		if new_count >= wait_max:
			new_count = wait_max # Cap the count
			on_max_action.call()
	else:
		if new_count > 10:
			new_count -= fade_speed
		elif new_count < 10: # Prevent going below the minimum
			new_count = 10

	# Update label alpha
	if label_node:
		label_node.modulate.a = new_count / wait_max

	return new_count # Return the updated count
