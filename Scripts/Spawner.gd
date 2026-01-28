# res://scripts/Spawner.gd
extends Node

@export var melee_scene: PackedScene
@export var ranged_scene: PackedScene
@export var spawn_per_sec := 2.0
@export var spawn_outside_margin := 220.0
@export var melee_ratio := 0.7

@onready var world := get_tree().current_scene.get_node("World")
@onready var enemies_root := get_tree().current_scene.get_node("World/Entities/Enemies")
@onready var player := get_tree().current_scene.get_node("World/Entities/Player")

var acc := 0.0

func _process(delta):
	acc += delta * spawn_per_sec
	while acc >= 1.0:
		acc -= 1.0
		_spawn_one()

func _spawn_one():
	var vp := get_viewport().get_visible_rect().size
	var half := vp * 0.5

	var side := randi() % 4
	var screen_p := Vector2.ZERO
	match side:
		0: screen_p = Vector2(-half.x - spawn_outside_margin, randf_range(-half.y, half.y))
		1: screen_p = Vector2( half.x + spawn_outside_margin, randf_range(-half.y, half.y))
		2: screen_p = Vector2(randf_range(-half.x, half.x), -half.y - spawn_outside_margin)
		3: screen_p = Vector2(randf_range(-half.x, half.x),  half.y + spawn_outside_margin)

	var enemy_world_pos :Vector2 = world.screen_to_world(screen_p)

	var scene := melee_scene if randf() < melee_ratio else ranged_scene
	var e := scene.instantiate()
	enemies_root.add_child(e)
	e.world_pos = enemy_world_pos
	e.update_screen_pos()
	e.set_target(player)
