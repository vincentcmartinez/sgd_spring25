extends Camera2D
@onready var day: Label = $Control/VBoxContainer/HBoxContainer/day
@onready var time: Label = $Control/VBoxContainer/HBoxContainer/time
@onready var money: Label = $Control/VBoxContainer/HBoxContainer2/money
@onready var item_label: Label = $"Control/VBoxContainer/HBoxContainer2/item label"



var inv = null
var signaled = false
var inv_cooldown = false
var inv_showing = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not signaled:
		signaled = true
		SignalBus.emit_signal("cam_ready", self)
	set_day_label()
	set_time_label()
	set_money_label()
	#set_active_item_label()
	pass

func set_day_label():
	day.text = "Day: " + str(DayManager.day_num)

func set_time_label():
	time.text = "Time: " + DayManager.get_time_string()

func set_money_label():
	var currentMoney = PlayerData.get_current_money()
	if currentMoney != null:
		if currentMoney < 1:
			money.text = "Money: broke AF LMAO"
		else:
			money.text = "Money: " + str(currentMoney)

func set_active_item_label():
	var active_item = PlayerData.get_active_item()
	if active_item:
		item_label.text = "Active item: " + str(active_item.name)
	else:
		item_label.text = "Active item: none"
	
func open_inv():
	if inv_cooldown:
		return
	if inv_showing:
		close_inv()
		return
	SignalBus.emit_signal("inv_opened")
	inv_showing = true
	inv = load("res://assets/scenes/inventory_screen.tscn").instantiate()
	add_child(inv)
	$Hotbar.hide()
	
func close_inv():
	SignalBus.emit_signal("inv_closed")
	remove_child(inv)
	inv.queue_free()
	inv_cooldown = true
	inv_showing = false
	$Hotbar.show()
	await get_tree().create_timer(0.5).timeout
	inv_cooldown = false
	
