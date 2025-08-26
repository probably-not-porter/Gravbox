extends Node2D

var levelMap = [{'x':0,'y':0}];

func _draw():
	var min_x = levelMap[0].x;
	var max_x = levelMap[0].x;
	var min_y = levelMap[0].y;
	var max_y = levelMap[0].y;

	# Find the bounding box
	for pix in levelMap:
		min_x = min(float(min_x), float(pix.x));
		max_x = max(float(max_x), float(pix.x));
		min_y = min(float(min_y), float(pix.y));
		max_y = max(float(max_y), float(pix.y));

	# Calculate the center of the bounding box
	var center_x = (min_x + max_x) / 2.0;
	var center_y = (min_y + max_y) / 2.0;
	var center_offset = Vector2(center_x, center_y);

	# Draw the rectangles, offset by the calculated center
	for pix in levelMap:
		var rect_pos = Vector2(float(pix.x), float(pix.y)) - center_offset;
		draw_rect(Rect2(rect_pos, Vector2(1, 1)), Color.WHITE);
		
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
