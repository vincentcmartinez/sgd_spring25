extends Node2D

@export var speed := 200
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var money = 0
var actionable = true
var inventory = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null]


func _ready() -> void:
	SignalBus.connect("interact", interact)
	#SignalBus.connect("items_ready", _on_items_ready)
	inventory[0] = Items.get_item(1) # debug watercan 
	SignalBus.emit_signal("player_ready", self)

func _on_items_ready():
	print("player recieved items ready")
	inventory[0] = Items.get_item(1) # debug watercan 
	SignalBus.emit_signal("player_ready", self)

func _process(delta: float) -> void:
	if not actionable:
		return
	var velocity: Vector2 = Vector2.ZERO
	# Check for input to set the velocity
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		animated_sprite.play("walk_up")
	elif Input.is_action_pressed("down"):
		velocity.y += 1
		animated_sprite.play("walk_down")
	elif Input.is_action_pressed("left"):
		velocity.x -= 1
		animated_sprite.play("walk_left")
	elif Input.is_action_pressed("right"):
		velocity.x += 1
		animated_sprite.play("walk_right")
	# If no input is detected, stop the animation
	if velocity == Vector2.ZERO:
		animated_sprite.stop()
		animated_sprite.frame = 0  # Reset the animation to the first frame

	# Normalize the velocity to prevent faster diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	# Move the character
	position += velocity * delta
	return
	

func interact(obj):
	if obj is flower:
		water(obj)
	pass

func water(obj):
	if held_item() is Watercan:
		if held_item().use():
			SignalBus.emit_signal("plant_watered", obj)
			play_directional_anim(obj, "water")

func play_directional_anim(obj, action:String):
	# Calculate the direction from the player to the plant
			var direction = (obj.global_position - global_position).normalized()
			# Determine the animation to play based on the direction
			var animation = action + "_"
			if abs(direction.x) > abs(direction.y):
				if direction.x > 0:
					animation += "right"
				else:
					animation += "left"
			else:
				if direction.y > 0:
					animation += "down"
				else:
					animation += "up"
			actionable = false
			animated_sprite.play(animation)
			await animated_sprite.animation_finished
			actionable = true

func held_item():
	return inventory[0]
