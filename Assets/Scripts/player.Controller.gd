extends CharacterBody2D
var grav = Vector2(980, 980)
var grid_size = 16

func _physics_process(delta: float) -> void:
	
	print(position)
	if Input.is_action_just_pressed("left") and velocity == Vector2(0,0):
		print("Left")
		position = get_snapped_position()
		grav = Vector2(-980,0)
	if Input.is_action_just_pressed("right") and velocity == Vector2(0,0):
		print("Right")
		position = get_snapped_position()
		grav = Vector2(980,0)
	if Input.is_action_just_pressed("up") and velocity == Vector2(0,0):
		print("Up")
		position = get_snapped_position()
		grav = Vector2(0,-980)
	if Input.is_action_just_pressed("down") and velocity == Vector2(0,0):
		print("Down")
		position = get_snapped_position()
		grav = Vector2(0,980)
		
		
	velocity += grav * delta
	
	move_and_slide()
	
func get_snapped_position() -> Vector2:
	return Vector2(
		round(position.x / grid_size) * grid_size,
		round(position.y / grid_size) * grid_size
	)
