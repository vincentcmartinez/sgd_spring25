extends Node
@onready var debugmenu = preload("res://assets/scenes/debug/debugmenu.tscn").instantiate()
var camera = null
var debug_menu_open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("cam_ready", _on_camera_ready)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("debugmenu") and not debug_menu_open:
		open_menu()
	if Input.is_action_pressed("closedebugmenu") and debug_menu_open:
		close_menu()
	pass

func open_menu():
	camera.add_child(debugmenu)
	debug_menu_open = true
	return

func close_menu():
	camera.remove_child(debugmenu)
	debug_menu_open = false
	return

func _on_camera_ready(cam): # wait until the main scene's camera is loaded, since this script is autoload and might load before the camera is ready
	camera = cam
	return
