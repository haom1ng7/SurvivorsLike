# res://scripts/EnemyBase.gd
extends CharacterBody2D
signal died(world_pos: Vector2)

@export var max_hp := 20.0
@export var move_speed := 120.0
@export var exp_drop := 3

var hp := 20.0
var target: Node2D
var world_pos := Vector2.ZERO

@onready var world := get_tree().current_scene.get_node("World") as World

func _ready():
	hp = max_hp

func set_target(t: Node2D) -> void:
	target = t

func take_damage(amount: float):
	hp -= amount
	if hp <= 0:
		died.emit(world_pos)
		queue_free()

func wrap_world_pos():
	world_pos = world.wrap_offset(world_pos)

func update_screen_pos():
	global_position = world.world_to_screen(world_pos)
