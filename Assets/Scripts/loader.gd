extends Node2D
@export var gridSize: int = 16;
var gameProps = {
	"player": preload("res://Assets/Props/player.tscn"),
	"block": preload("res://Assets/Props/block.tscn"),
	"key_block": preload("res://Assets/Props/key_block.tscn"),
	"lock_block": preload("res://Assets/Props/lock_block.tscn"),
	"finish_block": preload("res://Assets/Props/finish_block.tscn")
}
var skip = false;
var start = false;
var loadLevel = false;
var txt = "%% Placeholder text %%"
var quitCount = 0;

func _ready() -> void:
	if Globals.currentLevel != null:
		load_current_level_text();
		$Fade.fade_out();
		await play_text();
	
	
		
func _process(delta):
	if Input.is_action_pressed("quit"):
		quitCount += 1;
		if quitCount == 200:
			await $Fade.fade_in();
			get_tree().change_scene_to_file("res://Assets/Scenes/menu.tscn");
	else:
		quitCount = 0;
	if(Input.is_anything_pressed()==true):
		if start == false:
			$ScreenText.text = txt;
			$SkipText.visible = true;
			skip = true;
			await get_tree().create_timer(0.5).timeout;
			start = true;
			
		else:
			if Globals.currentLevel != null and loadLevel == false:
				loadLevel = true;
				await $Fade.fade_in();
				remove_loadscreen();
				load_current_level();
				await $Fade.fade_out();
				Globals.gameRunning = true;
			
func play_text():
	for x in txt:
		if skip == false:
			await get_tree().create_timer(0.05).timeout;
			$LetterSound.play()
			$ScreenText.text += x;
	await get_tree().create_timer(0.5).timeout;
	start = true;
	$SkipText.visible = true;
	
func remove_loadscreen():
	$ScreenText.visible = false;
	$SkipText.visible = false;
	
func load_current_level_text():
	var json_as_text = FileAccess.get_file_as_string(Globals.currentLevel)
	var level_obj = JSON.parse_string(json_as_text)
	if level_obj.has('openingText'):
		txt = level_obj.openingText;
	else:
		return 1
	
func load_current_level():
	var json_as_text = FileAccess.get_file_as_string(Globals.currentLevel)
	var level_obj = JSON.parse_string(json_as_text)
	for item in level_obj.contents:
		var newnode = gameProps[item.type].instantiate()
		
		if item.type == "key_block" or item.type == "lock_block":
			newnode.id = int(item.id);

		if item.type == "finish_block":
			newnode.nextLevel = null;
			
		newnode.position = Vector2(
			int(item.x) * gridSize,
			int(item.y) * gridSize);
		add_child(newnode);
	
	
