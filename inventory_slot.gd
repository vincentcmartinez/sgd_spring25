extends Node2D
var is_hovered = false
var item = null
@export var index:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await SignalBus.playerdata_ready
	var invitem = PlayerData.inventory(index)
	if invitem:
		add_child(invitem)
		item = invitem 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attach_item(new_item):
	item = new_item

func _on_clickbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	SignalBus.emit_signal("invslot_clicked", self)
	pass # Replace with function body.


func _on_clickbox_mouse_entered() -> void:
	SignalBus.emit_signal("invslot_hovered", self)
	pass # Replace with function body.


func _on_clickbox_mouse_exited() -> void:
	SignalBus.emit_signal("invslot_unhovered", self)
	pass # Replace with function body.
