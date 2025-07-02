extends StaticBody2D

@export var startTapped = false;
var frame: int = 15;
var tapped = false;

func _ready():
	add_to_group("blocks")
	if startTapped:
		tap();

func tap():
	if tapped == false:
		tapped = true;
		while frame < 26:
			frame = frame + 1;
			$Animation.frame = frame;
			await get_tree().create_timer(0.05).timeout
