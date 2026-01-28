# res://scripts/Shard.gd
extends Area2D

@export var exp_value := 3
var world_pos := Vector2.ZERO
@onready var world := get_tree().current_scene.get_node("World")

func setup_world(pos: Vector2):
	world_pos = world.wrap_offset(pos)

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	global_position = world.world_to_screen(world_pos)

func _on_body_entered(body):
	if body.has_method("add_exp"):
		body.add_exp(exp_value)
	queue_free()
