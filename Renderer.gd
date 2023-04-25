extends Node2D

var distances = []
@export var player = CharacterBody2D # Have to assign in editor!
@export var screen_width = 0
@export var screen_height = 0
@export var wall_height = 15000
@export var color_hue = 0.66
@export var color_saturation = 1
@export var color_dropoff = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distances = player.distances
	queue_redraw()
	print(Engine.get_frames_per_second())
	
	
func _draw():
	if len(distances) == 0:
		return
	
	var x = 0
	var line_width = screen_width / len(distances)
	
	for distance in distances:
		if not distance[0]:
			x += line_width
			continue
		
		var corrected_distance = distance[0] * cos(distance[1])
		var height = wall_height / corrected_distance
		
		var color_value = player.max_distance/(distance[0]*color_dropoff)
		if color_value > 0.9:
			color_value = 0.9
		
		var color = Color.from_hsv(color_hue, color_saturation, color_value)
		
		draw_line(Vector2(x, screen_height/2 - height), Vector2(x, screen_height/2 + height), color, line_width)
		
		x += line_width
