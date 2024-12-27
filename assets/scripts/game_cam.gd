extends Camera2D
@onready var day: Label = $Control/HBoxContainer/day
@onready var time: Label = $Control/HBoxContainer/time
@onready var money: Label = $Control/HBoxContainer/money

var signaled = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not signaled:
		signaled = true
		SignalBus.emit_signal("cam_ready", self)
	set_day_label()
	set_time_label()
	set_money_label()
	pass

func set_day_label():
	day.text = "Day: " + str(DayManager.day_num)

func set_time_label():
	time.text = "Time: " + DayManager.get_time_string()

func set_money_label():
	var currentMoney = PlayerData.get_current_money()
	if currentMoney != null:
		money.text = "Money: " + str(currentMoney)
