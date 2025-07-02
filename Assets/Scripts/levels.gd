extends Control

var button = preload("res://Assets/Props/Button.tscn")
func _ready():
	var user_levels : String = OS.get_executable_path().get_base_dir() + "/levels/";
	var main_levels : String = "res://Assets/Levels/";
	get_levels(user_levels);
	get_levels(main_levels);
	
func get_levels(lv_path):

	var level_scenes := Globals.get_all_files(lv_path, ".json")
	for level in level_scenes:
		if validate_level(level):
			make_level_button(level);
		
func validate_level(level):
	print(level);
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
