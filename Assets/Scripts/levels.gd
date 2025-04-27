extends Control

func _ready():
	# Get internal levels
	var level_scenes := Globals.get_all_files("res://Assets/Levels/", ".json")
	for level in level_scenes:
		if validate_level(level):
			make_level_button(level);
		
func validate_level(level):
	return true; #TODO

func make_level_button(level):
	var json_as_text = FileAccess.get_file_as_string(level)
	var level_obj = JSON.parse_string(json_as_text)
	var btn = Button.new() # or create a button scene instead
	btn.pressed.connect(func(): load_level(level))
	btn.text = level_obj.name;
	$LevelButtons.add_child(btn);
		
func load_level(level):
	Globals.currentLevel = level;
	get_tree().change_scene_to_file("res://Assets/Scenes/loader.tscn");
