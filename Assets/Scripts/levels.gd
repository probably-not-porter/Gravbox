extends Control

var button = preload("res://Assets/Props/Button.tscn");
var level_scenes = [];
var level_index = 0;

func _ready():
	var user_levels : String = "user://levels/";
	var dir = DirAccess.open("user://") # Open the user data directory.

	# Check if the "levels" folder already exists.
	if not dir.dir_exists("levels"):
		# If not, create it.
		dir.make_dir("levels");
		
	Globals.gameMode = 0;
	$UI/Buttons/PrevButton.disabled = true;
	get_levels(user_levels);
	
func get_levels(lv_path):
	var tmp_level_scenes = Globals.get_all_files(lv_path, ".json")
	if len(tmp_level_scenes) == 0:
		_check_buttons();
		$UI/Buttons/PlayButton.disabled = true;
		return false
	
	# Validate Levels
	for tmp_level in tmp_level_scenes:
		if validate_level(tmp_level):
			level_scenes.append(tmp_level)
			#make_level_button(level);
			
	display_level(level_scenes[level_index]);
	return true
		
func validate_level(level):
	return true; #TODO
	
func display_level(level):
	_check_buttons()
	var level_data = _get_level_data(level);
	var level_author = "Unknown"
	if "author" in level_data:
		level_author = level_data.author;
	$UI/Preview.show_preview(level);
	
	$UI/Text/LevelInfoText.text = "[center][font_size=48]";
	$UI/Text/LevelInfoText.text += level_data.name;
	$UI/Text/LevelInfoText.text += "[/font_size]\n";
	$UI/Text/LevelInfoText.text += "[color=#555555][font_size=32]by ";
	$UI/Text/LevelInfoText.text += level_author;
	$UI/Text/LevelInfoText.text += "[/font_size][/color][/center]"
	
	$UI/Text/LevelNumText.text = "[center][font_size=32]" + str(level_index + 1 ) + "/" + str(len(level_scenes)) + "[/font_size][/center]";

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

func _check_buttons() -> void:
	if len(level_scenes) == 0:
		$UI/Buttons/PrevButton.disabled = true;
		$UI/Buttons/NextButton.disabled = true;
	elif level_index == 0:
		$UI/Buttons/PrevButton.disabled = true;
		$UI/Buttons/NextButton.disabled = false;
	elif len(level_scenes) > level_index + 1:
		$UI/Buttons/PrevButton.disabled = false;
		$UI/Buttons/NextButton.disabled = false;
	else:
		$UI/Buttons/PrevButton.disabled = false;
		$UI/Buttons/NextButton.disabled = true;
		
func _on_prev_button_pressed() -> void:
	if level_index > 0:
		level_index = level_index - 1;
	display_level(level_scenes[level_index]);

func _on_next_button_pressed() -> void:
	if level_index < len(level_scenes)-1:
		level_index = level_index + 1;
	display_level(level_scenes[level_index]);

func _on_play_button_pressed() -> void:
	load_level(level_scenes[level_index]);

func _on_dir_button_pressed() -> void:
	var user_levels = "user://levels/";
	var full_path = ProjectSettings.globalize_path(user_levels)
	OS.shell_open(full_path);

func _on_editor_button_pressed() -> void:
	OS.shell_open("https://probably-not-porter.github.io/Gravbox/")
