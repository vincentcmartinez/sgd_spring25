extends Node
var frozen = false
var day_num = 0
var time = 0
const DAY_LENGTH = 6 #num of seconds (real life) in a day (game)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not frozen:
		time += delta
	if time >= 600:
		end_day()
	pass

func end_day():
	time = 0
	day_num += 1 
	SignalBus.emit_signal("day_end")
	print("day ended")

func freeze():
	frozen = true
	
func unfreeze():
	frozen = false
