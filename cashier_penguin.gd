extends Node2D

@onready var register = get_parent().get_node("Register")

func _ready() -> void:
	global_position = register.global_position + Vector2(40, -10)
	register.add_cashier()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 14, Color.MEDIUM_PURPLE)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-22, -20), "Cashier", HORIZONTAL_ALIGNMENT_LEFT, -1, 10)
