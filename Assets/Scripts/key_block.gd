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

func _on_body_entered(body):
	if body.name == "Player":
		unlock_locks()

func unlock_locks():
	for lock_n in get_tree().get_nodes_in_group("locks"):
		if lock_n.id == id:
			await lock_n.unlock();
			lock_n.queue_free()

func get_lock_with_id(lock_id: int) -> Node2D:
	for lock_n in get_tree().get_nodes_in_group("locks"):
		if lock_n.id == lock_id:
			return lock_n
	return null

func update_line():
	if lock:
		line.clear_points()
		line.add_point(line.to_local(global_position))
		line.add_point(line.to_local(Vector2(lock.global_position.x,global_position.y)))
		line.add_point(line.to_local(lock.global_position))
