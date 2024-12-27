extends Node

signal day_end
signal plant_watered
signal interact
signal cam_ready
signal player_ready
signal items_ready
signal playerdata_ready
signal invslot_clicked
signal invslot_hovered
signal invslot_unhovered
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func emit(str):
	emit_signal(str)
	print("emitted: ", str)
