extends StaticBody2D

@export var id: int
var line: Line2D
var lock: Node2D

func _ready():
	line = $Line2D
	add_to_group("keys")
	lock = get_lock_with_id(id)
	if lock:
		update_line()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		unlock_locks()

func unlock_locks():
	for lock in get_tree().get_nodes_in_group("locks"):
		if lock.id == id:
			await lock.unlock();
			lock.queue_free()

func get_lock_with_id(id: int) -> Node2D:
	for lock in get_tree().get_nodes_in_group("locks"):
		if lock.id == id:
			return lock
	return null

func update_line():
	if lock:
		line.clear_points()
		line.add_point(line.to_local(global_position))
		line.add_point(line.to_local(Vector2(lock.global_position.x,global_position.y)))
		line.add_point(line.to_local(lock.global_position))
