#class to store player data to savefile, and for other classes to globally access the player's data 
extends Node
var player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("player_ready", _on_player_ready)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func get_current_money():
	if player:
		return player.money
	else:
		return null
		
func _on_player_ready(obj):
	print("playerdata recieved player ready")
	player = obj
	SignalBus.emit("playerdata_ready")

func inventory(index):
	if(player):
		return player.inventory[index]
