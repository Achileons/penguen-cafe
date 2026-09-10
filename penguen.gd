extends CharacterBody2D

const SPEED = 200.0
const MAX_FISH = 3

var fish_carried: int = 0

func _draw() -> void:
	draw_circle(Vector2.ZERO, 20, Color.BLACK)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-20, -30), "Fish: %d/%d" % [fish_carried, MAX_FISH], HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
	if fish_carried >= MAX_FISH:
		draw_string(font, Vector2(-18, -50), "MAX!", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.RED)

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	velocity = direction.normalized() * SPEED if direction != Vector2.ZERO else Vector2.ZERO
	move_and_slide()

func add_fish(amount: int) -> bool:
	if fish_carried >= MAX_FISH:
		return false
	fish_carried = min(fish_carried + amount, MAX_FISH)
	queue_redraw()
	return true

func give_fish(amount: int) -> int:
	var given: int = min(fish_carried, amount)
	fish_carried -= given
	queue_redraw()
	return given
