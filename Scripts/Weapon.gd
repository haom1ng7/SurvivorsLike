# res://scripts/Weapon.gd
extends Node2D

@export var bullet_scene: PackedScene
@export var bullet_speed := 900.0

@onready var cd := $ShootCooldown as Timer
@onready var muzzle := $Muzzle as Node2D
@onready var player := get_parent() as CharacterBody2D
@onready var world := get_tree().current_scene.get_node("World") as Node2D
@onready var projectiles_root: Node = get_tree().current_scene.get_node("World/Entities/Projectiles")

func _process(_delta):
	if Input.is_action_pressed("shoot"):
		_try_shoot()

func _try_shoot():
	if cd.time_left > 0:
		return
	var atk_spd: float = max(0.2, player.attack_speed)
	cd.start(1.0 / atk_spd)

	var spawn_world: Vector2 = world.screen_to_world(muzzle.global_position)
	var base_dir := (get_global_mouse_position() - muzzle.global_position).normalized()
	var base_angle := base_dir.angle()

	var count: int = player.projectile_count
	var arc: float = deg_to_rad(player.spread_arc)
	
	for i in range(count):
		var angle_offset := 0.0
		if count > 1:
			var step := arc / (count - 1) if count > 1 else 0.0
			# 让散射居中: -half_arc 到 +half_arc
			angle_offset = -arc * 0.5 + i * step
		
		var current_angle := base_angle + angle_offset
		var dir := Vector2.from_angle(current_angle)

		var b := bullet_scene.instantiate()
		projectiles_root.add_child(b)
		b.setup_world(spawn_world, dir, bullet_speed, player.attack)
