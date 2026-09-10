extends Area2D

const MAX_STOCK := 10
var stock: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _draw() -> void:
	draw_rect(Rect2(-30, -30, 60, 60), Color.SKY_BLUE)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-30, -40), "Fish Station", HORIZONTAL_ALIGNMENT_LEFT, -1, 16)
	draw_string(font, Vector2(-30, -60), "Stock: %d/%d" % [stock, MAX_STOCK], HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
	if stock >= MAX_STOCK:
		draw_string(font, Vector2(-20, -80), "MAX!", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.RED)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("give_fish"):
		var space := MAX_STOCK - stock
		if space > 0:
			stock += body.give_fish(space)
			queue_redraw()

func take_fish() -> bool:
	if stock > 0:
		stock -= 1
		queue_redraw()
		return true
	return false

func receive_fish(amount: int) -> int:
	var space := MAX_STOCK - stock
	var accepted : int = min(space, amount)
	stock += accepted
	queue_redraw()
	return accepted
