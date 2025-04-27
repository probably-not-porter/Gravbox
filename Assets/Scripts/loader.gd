extends Node2D
@export var gridSize: int = 16;
var gameProps = {
	"player": preload("res://Assets/Props/player.tscn"),
	"block": preload("res://Assets/Props/block.tscn"),
	"key_block": preload("res://Assets/Props/key_block.tscn"),
	"lock_block": preload("res://Assets/Props/lock_block.tscn"),
	"finish_block": preload("res://Assets/Props/finish_block.tscn")
}

func _ready() -> void:
	var json_as_text = FileAccess.get_file_as_string(Globals.currentLevel)
	var level_obj = JSON.parse_string(json_as_text)
	for item in level_obj.contents:
		print(item)
		var newnode = gameProps[item.type].instantiate()
		
		if item.type == "key_block" or item.type == "lock_block":
			newnode.id = int(item.id);

		if item.type == "finish_block":
			newnode.nextLevel = null;
			
		newnode.position = Vector2(
			int(item.x) * gridSize,
			int(item.y) * gridSize);
		add_child(newnode);
