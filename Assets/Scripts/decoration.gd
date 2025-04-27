extends RigidBody2D
var gravity_vector = Vector2.ZERO

func _ready():
	add_to_group("decorations")


func set_gravity(direction: Vector2):
	print("setting direction")
	gravity_vector = direction

func _physics_process(delta):
	apply_central_force(gravity_vector * 200)  # Adjust the strength
