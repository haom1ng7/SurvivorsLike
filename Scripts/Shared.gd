# res://scripts/Shard.gd
extends Area2D

@export var exp_value := 3
var world_pos := Vector2.ZERO
var is_magnetized := false
var magnet_speed := 400.0

@onready var world := get_tree().current_scene.get_node("World")
@onready var player := get_tree().current_scene.get_node("World/Entities/Player")

func setup_world(pos: Vector2):
	world_pos = world.wrap_offset(pos)
	# 立即更新一次位置，防止首帧闪烁
	global_position = world.world_to_screen(world_pos)

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if is_magnetized:
		_process_magnet_move(delta)
	else:
		_check_pickup_range()
	
	global_position = world.world_to_screen(world_pos)

func _check_pickup_range():
	if not is_instance_valid(player): return
	
	# 计算在循环世界中到world.world_offset的最短距离
	var to_player = _get_vector_to_player()
	var dist_sq = to_player.length_squared()
	
	# 检查距离
	var range_sq = player.pickup_range * player.pickup_range
	if dist_sq < range_sq:
		is_magnetized = true

func _process_magnet_move(delta):
	if not is_instance_valid(player): return
	
	var to_player = _get_vector_to_player()
	var dist = to_player.length()
	
	# 加速
	magnet_speed += 800.0 * delta
	var move_dist = magnet_speed * delta
	
	# 防止飞过头
	if move_dist >= dist:
		world_pos = world.world_offset
	else:
		world_pos += to_player.normalized() * move_dist
	
	world_pos = world.wrap_offset(world_pos)

func _get_vector_to_player() -> Vector2:
	var player_pos = world.world_offset
	var diff = player_pos - world_pos
	diff.x = world.wrap_nearest(diff.x, world.world_size.x)
	diff.y = world.wrap_nearest(diff.y, world.world_size.y)
	return diff

func _on_body_entered(body):
	if body.has_method("add_exp"):
		body.add_exp(exp_value)
	queue_free()
