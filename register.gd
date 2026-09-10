extends Area2D

const PAYMENT := 5
const BASE_SERVE_TIME := 1.0
const QUEUE_SPACING := 40.0

var queue: Array = []
var player_present: bool = false
var cashier_count: int = 0
var serve_timer: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _draw() -> void:
	draw_rect(Rect2(-30, -30, 60, 60), Color.LIGHT_GREEN)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-25, -40), "Register", HORIZONTAL_ALIGNMENT_LEFT, -1, 16)
	if queue.size() > 0:
		draw_string(font, Vector2(-35, -60), "Queue: %d" % queue.size(), HORIZONTAL_ALIGNMENT_LEFT, -1, 14)

func customer_arrived(customer: Node2D) -> void:
	queue.append(customer)
	_reposition_queue()

func add_cashier() -> void:
	cashier_count += 1

func _current_serve_time() -> float:
	return max(0.2, BASE_SERVE_TIME - 0.2 * cashier_count)

func _reposition_queue() -> void:
	for i in queue.size():
		var slot: Vector2 = global_position + Vector2(-QUEUE_SPACING * i, 50)
		queue[i].set_queue_target(slot)

func _process(delta: float) -> void:
	var staffed := player_present or cashier_count > 0
	if staffed and queue.size() > 0:
		serve_timer += delta
		if serve_timer >= _current_serve_time():
			serve_timer = 0.0
			var customer = queue.pop_front()
			get_parent().add_money(PAYMENT)
			customer.mark_paid()
			_reposition_queue()
	else:
		serve_timer = 0.0
	queue_redraw()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_fish"):
		player_present = true

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("add_fish"):
		player_present = false
