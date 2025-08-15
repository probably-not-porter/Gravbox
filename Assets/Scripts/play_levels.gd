extends Control

var button = preload("res://Assets/Props/Button.tscn");

func _ready():
	var user_levels : String = OS.get_executable_path().get_base_dir() + "/levels/";
	var main_levels : String = "res://Assets/Levels/";
	#get_levels(user_levels);
	get_levels(main_levels);
	
func get_levels(lv_path):
	var level_scenes := Globals.get_all_files(lv_path, ".json");
	
	level_scenes.sort_custom(func(a, b):
		# Extract the number from the first string 'a'.
		var num_a_string = a.split(" ")[1].split(".")[0]
		var num_a = int(num_a_string)
		# Extract the number from the second string 'b'.
		var num_b_string = b.split(" ")[1].split(".")[0]
		var num_b = int(num_b_string)
		# Return true if the number from 'a' is less than the number from 'b'.
		return num_a < num_b
	);
	
	for level in level_scenes:
		if validate_level(level):
			make_level_button(level);
	
func validate_level(level):
	return true; #TODO

func make_level_button(level):
	var json_as_text = FileAccess.get_file_as_string(level);
	var level_obj = JSON.parse_string(json_as_text);
	var btn = button.instantiate();
	btn.pressed.connect(func(): load_level(level));
	btn.text = level_obj.name;
	$LevelButtons.add_child(btn);
	
func load_level(level):
	Globals.currentLevel = level;
	get_tree().change_scene_to_file("res://Assets/Scenes/loader.tscn");

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/menu.tscn");
