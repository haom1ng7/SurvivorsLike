# res://scripts/EnemyRanged.gd
extends "res://scripts/EnemyBase.gd"

@export var desired_range := 380.0
@export var shoot_interval := 1.2
@export var bullet_scene: PackedScene
@export var bullet_speed := 520.0
@export var bullet_damage := 6.0

func _ready():
	super._ready()
	$ShootTimer.wait_time = shoot_interval
	$ShootTimer.timeout.connect(_shoot)
	$ShootTimer.start()

func _physics_process(delta):
	if target == null:
		return

	var player_world := world.world_offset
	var to_player := player_world - world_pos
	to_player.x = world.wrap_nearest(to_player.x, world.world_size.x)
	to_player.y = world.wrap_nearest(to_player.y, world.world_size.y)
	var dist := to_player.length()
	var dir := to_player.normalized()

	if dist > desired_range:
		world_pos += dir * move_speed * delta
	elif dist < desired_range * 0.7:
		world_pos -= dir * move_speed * delta

	wrap_world_pos()
	update_screen_pos()

func _shoot():
	if target == null: return
	var player_world := world.world_offset
	var to_player := player_world - world_pos
	to_player.x = world.wrap_nearest(to_player.x, world.world_size.x)
	to_player.y = world.wrap_nearest(to_player.y, world.world_size.y)
	var dir := to_player.normalized()

	var b := bullet_scene.instantiate()
	get_tree().current_scene.get_node("World/Entities/Projectiles").add_child(b)
	# 穿透=1, is_enemy=true
	b.setup_world(world_pos, dir, bullet_speed, bullet_damage, 1, true)
