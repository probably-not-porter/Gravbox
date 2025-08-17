extends StaticBody2D

var frame: int = 15;
var tapped = false;

func _ready():
	add_to_group("blocks")
	$Fade.fade_out();

func tap():
	if tapped == false:
		tapped = true;
		
		while frame < 26:
			frame = frame + 1;
			$Animation.frame = frame;
			await get_tree().create_timer(0.05).timeout
		await get_tree().create_timer(0.5).timeout
		next_level();
			

	
func next_level():
	Globals.save_game();
	await $Fade.fade_in();
	get_tree().current_scene.load_main_menu();
