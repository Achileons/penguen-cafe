extends Area2D

signal purchased(new_level: int)

@export var upgrade_name: String = "Upgrade"
@export var base_cost: int = 50
@export var cost_multiplier: float = 1.5
@export var max_level: int = 0  # 0 = sınırsız

var level: int = 0
var player_nearby: Node2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func is_maxed() -> bool:
	return max_level > 0 and level >= max_level

func current_cost() -> int:
	return int(base_cost * pow(cost_multiplier, level))

func _draw() -> void:
	draw_rect(Rect2(-30, -30, 60, 60), Color.GOLD)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-30, -40), "%s (Lv %d)" % [upgrade_name, level], HORIZONTAL_ALIGNMENT_LEFT, -1, 13)
	if is_maxed():
		draw_string(font, Vector2(-30, -58), "Owned", HORIZONTAL_ALIGNMENT_LEFT, -1, 13)
	else:
		draw_string(font, Vector2(-30, -58), "Cost: %d" % current_cost(), HORIZONTAL_ALIGNMENT_LEFT, -1, 13)
		if player_nearby != null:
			draw_string(font, Vector2(-30, -76), "Press Space to buy!", HORIZONTAL_ALIGNMENT_LEFT, -1, 13)

func _process(_delta: float) -> void:
	if not is_maxed() and player_nearby != null and Input.is_action_just_pressed("ui_accept"):
		_try_purchase()
	queue_redraw()

func _try_purchase() -> void:
	if get_parent().spend_money(current_cost()):
		level += 1
		purchased.emit(level)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_fish"):
		player_nearby = body

func _on_body_exited(body: Node2D) -> void:
	if body == player_nearby:
		player_nearby = null
