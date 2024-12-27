extends Node2D
var current_hovered = null
var last_hovered = null
var dragging = false
var selected_slot = null
@onready var overflow_slot = $overflow

func _ready() -> void:
	SignalBus.connect("invslot_clicked", _on_click)
	SignalBus.connect("invslot_hovered", _on_hover)
	SignalBus.connect("invslot_unhovered", _on_unhover)
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("leftclick"):
		
		dragging = true
		selected_slot = current_hovered
		if overflow_slot.item:
			swap(overflow_slot, current_hovered)
		print("dragging")
	if event.is_action_released("leftclick"):
		dragging = false
		if selected_slot:
			if current_hovered:
				swap(selected_slot, current_hovered)
			else:
				drop()
			#selected_slot = null
		print("dragging false")
	if event.is_action_pressed("split_item"):
		if selected_slot:
			split(selected_slot)

func _process(delta: float) -> void:
	if selected_slot:
		$debug/VBoxContainer/selected.text = "selected index: " + str(selected_slot.index)
	else:
		$debug/VBoxContainer/selected.text = "selected index: None " 
	pass

func _on_click(slot):
	selected_slot = slot
	return

func _on_hover(slot):
	current_hovered = slot
	print("hovered", slot.index)
	return

func _on_unhover(slot):
	if current_hovered:
		last_hovered = current_hovered
	current_hovered = null
	print("last hovered", last_hovered.index)
	return

func swap(current, other):
	if current == other or other == null:
		return
	var selected_item = current.item
	var other_item = other.item
	if other_item and selected_item.ID == other_item.ID:
		if selected_item.stackable and (selected_item.count + other_item.count <= selected_item.max_stack):
			other.add_stack(current)
			current.remove_item()
			PlayerData.remove_inv(current.index)
			return
	current.attach_item(other_item)
	other.attach_item(selected_item)
	PlayerData.swap_inv(other.index, current.index)

func drop():
	print("dropped item")
	return

func split(slot):
	var item = slot.item
	if item and item.stackable and item.count > 1:
		
		var new_item = Items.clone(item)
		new_item.count = item.count - int(item.count / 2)
		slot.split_stack()
		selected_slot = overflow_slot

		overflow_slot.attach_item(new_item)
