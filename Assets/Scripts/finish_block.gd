extends StaticBody2D

@export var nextLevel = null;
var frame: int = 15;
var tapped = false;

func _ready():
	add_to_group("blocks")

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
		await get_tree().create_timer(0.8).timeout
		get_tree().current_scene.load_main_menu();
	else:
		get_tree().current_scene.load_main_menu();
