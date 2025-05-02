extends StaticBody2D

@export var nextLevel = null;
var frame: int = 15;
var tapped = false;

func _ready():
	add_to_group("blocks")
	connect("body_entered", Callable(self, "_on_body_entered"))

func tap():
	if tapped == false:
		tapped = true;
		next_level();
		while frame < 26:
			frame = frame + 1;
			$Animation.frame = frame;
			await get_tree().create_timer(0.05).timeout

func next_level():
	if nextLevel == null:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Assets/Scenes/menu.tscn");
	else:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Assets/Scenes/levels/level%s.tscn" % nextLevel);
	print("Next Level TODO")
