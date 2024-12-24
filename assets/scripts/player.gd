extends Node2D

@export var speed := 200
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var actionable = true
var inventory = [null, null, null, null, null, null, null, null, null, null]
#var held_item = inventory[0]
var held_item = preload("res://assets/scenes/items/watercan.tscn").instantiate()
func _ready() -> void:
	SignalBus.connect("interact", interact)
	
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
	if held_item is Watercan:
		if held_item.use():
			SignalBus.emit_signal("plant_watered", obj)
			# Calculate the direction from the player to the plant
			var direction = (obj.global_position - global_position).normalized()
			# Determine the animation to play based on the direction
			var animation = ""
			if abs(direction.x) > abs(direction.y):
				if direction.x > 0:
					animation = "water_right"
				else:
					animation = "water_left"
			else:
				if direction.y > 0:
					animation = "water_down"
				else:
					animation = "water_up"
			actionable = false
			animated_sprite.play(animation)
			await animated_sprite.animation_finished
			actionable = true
