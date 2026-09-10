extends Area2D

var nearby_body: Node2D = null
var catch_timer: float = 0.0
const CATCH_TIME := 1.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _draw() -> void:
	draw_rect(Rect2(-40, -40, 80, 80), Color.LIGHT_BLUE)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-35, -55), "Ice Pond", HORIZONTAL_ALIGNMENT_LEFT, -1, 16)
	if nearby_body != null:
		draw_string(font, Vector2(-35, -75), "Catching... %.1f" % (CATCH_TIME - catch_timer), HORIZONTAL_ALIGNMENT_LEFT, -1, 14)

func _process(delta: float) -> void:
	if nearby_body != null:
		catch_timer += delta
		if catch_timer >= CATCH_TIME:
			catch_timer = 0.0
			nearby_body.add_fish(1)
	queue_redraw()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_fish"):
		nearby_body = body
		catch_timer = 0.0

func _on_body_exited(body: Node2D) -> void:
	if body == nearby_body:
		nearby_body = null
		catch_timer = 0.0
