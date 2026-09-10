extends Node2D

var money: int = 0
const CustomerScene = preload("res://customer.tscn")
const AssistantScene = preload("res://assistant_penguin.tscn")
const CashierScene = preload("res://cashier_penguin.tscn")

var base_max_customers := 6
var max_customers := 6
var fisher_penguin: Node2D = null

func _ready() -> void:
	$CustomerTimer.timeout.connect(_on_customer_timer_timeout)
	$AssistantTile.purchased.connect(_on_fisher_purchased)
	$CashierTile.purchased.connect(_on_cashier_purchased)

func add_money(amount: int) -> void:
	money += amount
	$HUD/MoneyLabel.text = "Money: " + str(money)

func spend_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		$HUD/MoneyLabel.text = "Money: " + str(money)
		return true
	return false

func _on_customer_timer_timeout() -> void:
	$CustomerTimer.wait_time = randf_range(3.0, 6.0)
	if get_tree().get_nodes_in_group("customers").size() >= max_customers:
		return
	var customer = CustomerScene.instantiate()
	customer.position = Vector2(50, randf_range(450, 550))
	add_child(customer)

func _on_fisher_purchased(new_level: int) -> void:
	if fisher_penguin == null:
		fisher_penguin = AssistantScene.instantiate()
		fisher_penguin.position = $AssistantTile.global_position + Vector2(0, -60)
		add_child(fisher_penguin)
	else:
		fisher_penguin.apply_upgrade(new_level)
	max_customers = base_max_customers + (new_level - 1) * 2

func _on_cashier_purchased(_new_level: int) -> void:
	var cashier = CashierScene.instantiate()
	add_child(cashier)
