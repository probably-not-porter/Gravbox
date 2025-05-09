extends ColorRect


@export var speed = 1.2

func fade_in():
	while self.color.a < 1:
		self.color.a += 0.01 * speed;
		await get_tree().create_timer(0.01).timeout;

func fade_out():
	while self.color.a > 0:
		self.color.a -= 0.01 * speed;
		await get_tree().create_timer(0.01).timeout;
