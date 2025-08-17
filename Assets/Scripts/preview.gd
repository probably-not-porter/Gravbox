extends Node2D

var levelMap = [{'x':0,'y':0}];

func _draw():
	var min_x = levelMap[0].x
	var min_y = levelMap[0].y

	for pix in levelMap:
		if pix.x < min_x:
			min_x = pix.x
		if pix.y < min_y:
			min_y = pix.y
			
	for pix in levelMap:
		draw_rect(Rect2(float(pix.x) - float(min_x), float(pix.y) - float(min_y), 1.0, 1.0), Color.WHITE)
	
func show_preview(level):
	var data = _get_level_data(level);
	levelMap = data.contents;
	queue_redraw()
	
func _get_level_data(level) -> Dictionary:
	var file = FileAccess.open(level, FileAccess.READ)
	if not file:
		return {}
		
	var json_as_text = file.get_as_text()
	var level_obj = JSON.parse_string(json_as_text)
	return level_obj if typeof(level_obj) == TYPE_DICTIONARY else {}
