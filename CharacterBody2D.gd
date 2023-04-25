extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5

@export var max_distance = 750
@export var fov = 60
@export var scanlines = 1280

@export var distances = []

var rotation_direction = 0
var lines = []

func get_input():
	rotation_direction = Input.get_axis("rot_left", "rot_right")
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	velocity = velocity.rotated(rotation)

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	
	# Raycasting OwO
	var player_pos = get_transform().get_origin()
	var space_state = get_world_2d().direct_space_state
	
	lines = []
	distances = []
	var x = -fov / 2 # X is the actual angle of the ray relative to the player. Useful for lens-correction too.
	for i in scanlines:
		x += float(fov) / scanlines
		var ray_target_pos = player_pos + Vector2(cos(deg_to_rad(x) + rotation + deg_to_rad(-90)), sin(deg_to_rad(x) + rotation + deg_to_rad(-90))) * max_distance
		
		var query = PhysicsRayQueryParameters2D.create(player_pos, ray_target_pos)
		var result = space_state.intersect_ray(query)
		if result:
			distances.append([player_pos.distance_to(result.position), deg_to_rad(x)])
			lines.append([player_pos, result.position])
		else:
			distances.append([null, null])
	
	queue_redraw()

func _draw():
	for line in lines:
		var a = line[0] - get_transform().get_origin()
		var b = (line[1] - get_transform().get_origin()).rotated(-rotation)
		
		draw_line(a, b, Color(255, 0, 0), 1)
