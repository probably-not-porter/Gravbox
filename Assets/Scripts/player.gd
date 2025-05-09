extends CharacterBody2D

var grav = Vector2.ZERO
var grid_size = 8
var is_moving = false

func _physics_process(delta: float) -> void:
	if Globals.gameRunning:
		check_for_loss();
		if not is_moving:
			if Input.is_action_just_pressed("left"):
				start_move(Vector2.LEFT)
				for decoration in get_tree().get_nodes_in_group("decorations"):
					decoration.set_gravity(Vector2.LEFT)
				emit_arrow(0)
			elif Input.is_action_just_pressed("right"):
				start_move(Vector2.RIGHT)
				for decoration in get_tree().get_nodes_in_group("decorations"):
					decoration.set_gravity(Vector2.RIGHT)
				emit_arrow(180)
			elif Input.is_action_just_pressed("up"):
				start_move(Vector2.UP)
				for decoration in get_tree().get_nodes_in_group("decorations"):
					decoration.set_gravity(Vector2.UP)
				emit_arrow(270)
			elif Input.is_action_just_pressed("down"):
				start_move(Vector2.DOWN)
				for decoration in get_tree().get_nodes_in_group("decorations"):
					decoration.set_gravity(Vector2.DOWN)
				emit_arrow(90)
				
		velocity += grav * delta
		
			
		if is_moving:
			move_and_slide()
			if grav.y != 0:
				position.x = round(position.x / grid_size) * grid_size
			if grav.x != 0:
				position.y = round(position.y / grid_size) * grid_size



		
			
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("keys"):
			collider.unlock_locks()
		if collider and collider.is_in_group("blocks"):
			collider.tap();
		if collision.get_normal().dot(grav.normalized()) < -0.9999:
			stop_move()

func emit_arrow(a):
	$ArrowParticle.angle_min = a;
	$ArrowParticle.angle_max = a;
	$ArrowParticle.restart()

func check_for_loss():
	if abs(position.x) > 3000 or abs(position.y) > 3000:
		get_tree().reload_current_scene() # TODO

func start_move(direction: Vector2):
	position = get_snapped_position()
	grav = direction * 980
	is_moving = true


func stop_move():
	velocity = Vector2.ZERO
	grav = Vector2.ZERO
	is_moving = false
	position = get_snapped_position() # TODO returning correct position but something is fucking it up
	# Play sound
	$MoveStopSound.play()

func get_snapped_position() -> Vector2:
	return Vector2(
		round(position.x / grid_size) * grid_size,
		round(position.y / grid_size) * grid_size
	)
