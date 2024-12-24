class_name flower extends Interactable
@export var growth_time: int # amount of days it takes to reach next stage 
@export var hardiness: int # amount of days this plant can go without watering 
@onready var stages = [$seed, $sprout, $bud, $bloom, $dead]
var current_stage_index = 0
var watered = false
var days_since_growth = 0
var days_since_watered = 0
var dead = false
var bloomed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("day_end", age)
	SignalBus.connect("plant_watered", get_watered)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func age():
	print("days since growth: ",days_since_growth )
	print("days since watered: ",days_since_watered )
	if dead:
		return
	if watered:
		days_since_growth += 1
		if(days_since_growth == growth_time):
			grow()
	days_since_watered += 1
	if days_since_watered == hardiness and bloomed:
		die()
	watered = false
	return
	
func get_watered(body):
	if body == self and not watered and not dead:
		watered = true
		days_since_watered = 0
		pass
	else:
		pass

func grow():
	if not bloomed:
		stages[current_stage_index].hide()
		current_stage_index += 1
		stages[current_stage_index].show()
		days_since_growth = 0
		bloomed = (current_stage_index == stages.size() - 2)
		print(bloomed)
	pass
	
func die():
	dead = true
	stages[current_stage_index].hide()
	stages[stages.size() -1].show() # should always be dead sprite 
	pass
