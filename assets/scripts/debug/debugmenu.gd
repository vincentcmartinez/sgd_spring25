extends Control
var disabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.show()
	disabled = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_skipday_pressed() -> void:
	if disabled:
		return
	DayManager.end_day()
	pass # Replace with function body.


func _on_skipweek_pressed() -> void:
	if disabled:
		return
	for i in range(0,6):
		DayManager.end_day()
	pass # Replace with function body.


func _on_tree_exited() -> void:
	if disabled:
		return
	disabled = true
	pass # Replace with function body.
