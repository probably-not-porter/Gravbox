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
var loadLevel = false;

func _ready() -> void:
	await play_text("This is some text to display at the start of the game.");
	
		
func _process(delta):
	if(Input.is_anything_pressed()==true):
		if skip == false:
			await get_tree().create_timer(0.1).timeout;
			skip = true;
			
	if(Input.is_anything_pressed()==true):
		if skip == true:
			if Globals.currentLevel != null and loadLevel == false:
				loadLevel = true;
				load_current_level();
			
func play_text(txt):
	for x in txt:
		if skip == false:
			await get_tree().create_timer(0.05).timeout;
			$LetterSound.play()
			$ScreenText.text += x;
	$ScreenText.text = txt;
	await get_tree().create_timer(10).timeout;
	print(txt);
	
		
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
