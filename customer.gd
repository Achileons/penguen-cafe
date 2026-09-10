extends Node2D

enum State { TO_STATION, TAKING_FISH, TO_REGISTER, WAITING_TO_PAY, LEAVING }

const SPECIES := [
	{"name": "Polar Bear", "color": Color.WHITE},
	{"name": "Orca", "color": Color.BLACK},
	{"name": "Seal", "color": Color.SLATE_GRAY},
	{"name": "Arctic Fox", "color": Color.ANTIQUE_WHITE},
]

var state: State = State.TO_STATION
var speed: float = 120.0
var spawn_position: Vector2
var paid: bool = false
var queue_target: Vector2
var species: Dictionary

@onready var fish_station = get_parent().get_node("FishStation")
@onready var register = get_parent().get_node("Register")
@onready var station_target: Vector2 = fish_station.get_node("StandPoint").global_position
@onready var register_target: Vector2 = register.get_node("StandPoint").global_position

func _ready() -> void:
	species = SPECIES[randi() % SPECIES.size()]
	add_to_group("customers")
	spawn_position = global_position
	queue_target = register_target

func _draw() -> void:
	draw_circle(Vector2.ZERO, 18, species.color)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-15, 32), species.name, HORIZONTAL_ALIGNMENT_LEFT, -1, 12)
	var status_text := ""
	match state:
		State.TO_STATION: status_text = "Going to get fish..."
		State.TAKING_FISH: status_text = "Waiting for fish..."
		State.TO_REGISTER: status_text = "Heading to pay..."
		State.WAITING_TO_PAY: status_text = "Waiting in line..."
		State.LEAVING: status_text = "Thanks, bye!"
	if status_text != "":
		draw_string(font, Vector2(-55, -30), status_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14)

func _process(delta: float) -> void:
	match state:
		State.TO_STATION:
			_move_toward(station_target, delta)
			if global_position.distance_to(station_target) < 5.0:
				state = State.TAKING_FISH
		State.TAKING_FISH:
			if fish_station.take_fish():
				state = State.TO_REGISTER
		State.TO_REGISTER:
			_move_toward(register_target, delta)
			if global_position.distance_to(register_target) < 5.0:
				paid = false
				register.customer_arrived(self)
				state = State.WAITING_TO_PAY
		State.WAITING_TO_PAY:
			_move_toward(queue_target, delta)
			if paid:
				state = State.LEAVING
		State.LEAVING:
			_move_toward(spawn_position, delta)
			if global_position.distance_to(spawn_position) < 5.0:
				queue_free()
	queue_redraw()

func mark_paid() -> void:
	paid = true

func set_queue_target(pos: Vector2) -> void:
	queue_target = pos

func _move_toward(target: Vector2, delta: float) -> void:
	global_position = global_position.move_toward(target, speed * delta)
