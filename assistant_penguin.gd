extends Node2D

enum State { TO_POND, FISHING, TO_STATION }

var state: State = State.TO_POND
var speed: float = 150.0
var capacity: int = 1
var fish_carried: int = 0
var catch_timer: float = 0.0
const CATCH_TIME := 1.0
const SPEED_STEP := 40.0

@onready var ice_pond = get_parent().get_node("IcePond")
@onready var fish_station = get_parent().get_node("FishStation")
@onready var station_target: Vector2 = fish_station.get_node("StandPoint").global_position

func _ready() -> void:
	add_to_group("assistants")

func apply_upgrade(new_level: int) -> void:
	var upgrade_index := new_level - 1
	if upgrade_index <= 0:
		return
	if upgrade_index % 2 == 1:
		speed += SPEED_STEP
	else:
		capacity += 1

func _draw() -> void:
	draw_circle(Vector2.ZERO, 14, Color.LIGHT_BLUE)
	var font := ThemeDB.fallback_font
	var text := ""
	match state:
		State.TO_POND: text = "..."
		State.FISHING: text = "Fishing (%d/%d)" % [fish_carried, capacity]
		State.TO_STATION: text = "Delivering..."
	draw_string(font, Vector2(-22, -20), text, HORIZONTAL_ALIGNMENT_LEFT, -1, 10)

func _process(delta: float) -> void:
	match state:
		State.TO_POND:
			_move_toward(ice_pond.global_position, delta)
			if global_position.distance_to(ice_pond.global_position) < 5.0:
				catch_timer = 0.0
				state = State.FISHING
		State.FISHING:
			catch_timer += delta
			if catch_timer >= CATCH_TIME:
				catch_timer = 0.0
				fish_carried += 1
				if fish_carried >= capacity:
					state = State.TO_STATION
		State.TO_STATION:
			_move_toward(station_target, delta)
			if global_position.distance_to(station_target) < 5.0:
				var accepted: int = fish_station.receive_fish(fish_carried)
				fish_carried -= accepted
				if fish_carried <= 0:
					state = State.TO_POND
	queue_redraw()

func _move_toward(target: Vector2, delta: float) -> void:
	global_position = global_position.move_toward(target, speed * delta)
