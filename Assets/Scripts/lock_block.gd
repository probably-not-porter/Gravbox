extends StaticBody2D

@export var id: int
var frame: int = 31;
var unlocked = false;

func _ready():
	add_to_group("locks")

func unlock():
	if unlocked == false:
		while frame < 39:
			frame = frame + 1;
			$Animation.frame = frame;
			await get_tree().create_timer(0.1).timeout
		
			
