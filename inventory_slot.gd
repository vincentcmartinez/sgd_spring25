extends Node2D
var is_hovered = false
var item = null
@export var index:int
@export var is_overflow:bool

func _ready() -> void:
	await SignalBus.playerdata_ready
	var invitem = PlayerData.inventory(index)
	if invitem:
		attach_item(invitem)
	pass # Replace with function body.

func attach_item(new_item):
	if new_item == null:
		item = null
		$displaycount.text = ""
		return
	if new_item.get_parent():
		new_item.reparent(self, false)
	else:
		add_child(new_item)
	item = new_item
	update_display_count()

func remove_item():
	if item:
		remove_child(item)
		item.queue_free()
		item = null
	update_display_count()

func add_stack(other):
	item.count += other.item.count
	update_display_count()

func split_stack():
	item.count -= int(item.count / 2)
	update_display_count()
	
func update_display_count():
	if item == null:
		$displaycount.text = ""
	elif item.stackable:
		$displaycount.text = str(item.count)
	return
	
func _on_clickbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("leftclick"):
		SignalBus.emit_signal("invslot_clicked", self)
	pass # Replace with function body.

func _on_clickbox_mouse_entered() -> void:
	SignalBus.emit_signal("invslot_hovered", self)
	pass # Replace with function body.

func _on_clickbox_mouse_exited() -> void:
	SignalBus.emit_signal("invslot_unhovered", self)
	pass # Replace with function body.
