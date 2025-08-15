extends Control

var button = preload("res://Assets/Props/Button.tscn");
var level_scenes = [];
var level_index = 0;

func _ready():
	var user_levels : String = OS.get_executable_path().get_base_dir() + "/levels/";
	$PrevButton.disabled = true;
	get_levels(user_levels);
	
func get_levels(lv_path):
	var tmp_level_scenes := Globals.get_all_files(lv_path, ".json")
	
	# Validate Levels
	for tmp_level in tmp_level_scenes:
		if validate_level(tmp_level):
			level_scenes.append(tmp_level)
			#make_level_button(level);
			
	display_level(level_scenes[level_index]);
		
func validate_level(level):
	return true; #TODO
	
func display_level(level):
	var level_data = _get_level_data(level);
	$LevelInfoText.text = "[center]" + level_data.name + "[/center]";
	$LevelNumText.text = "[center]" + str(level_index + 1 ) + "/" + str(len(level_scenes)) + "[/center]";
func load_level(level):
	Globals.currentLevel = level;
	get_tree().change_scene_to_file("res://Assets/Scenes/loader.tscn");

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/menu.tscn");

func _get_level_data(level) -> Dictionary:
	var file = FileAccess.open(level, FileAccess.READ)
	if not file:
		return {}
		
	var json_as_text = file.get_as_text()
	var level_obj = JSON.parse_string(json_as_text)
	return level_obj if typeof(level_obj) == TYPE_DICTIONARY else {}

func _on_prev_button_pressed() -> void:
	if level_index > 0:
		level_index = level_index - 1;
	if level_index == 0:
		$PrevButton.disabled = true;
	else:
		$PrevButton.disabled = false;
		$NextButton.disabled = false;
	display_level(level_scenes[level_index]);

func _on_next_button_pressed() -> void:
	if level_index < len(level_scenes)-1:
		level_index = level_index + 1;
	if level_index == len(level_scenes)-1:
		$NextButton.disabled = true;
	else:
		$NextButton.disabled = false;
		$PrevButton.disabled = false;
	display_level(level_scenes[level_index]);

func _on_play_button_pressed() -> void:
	load_level(level_scenes[level_index]);
