# res://scripts/Bullet.gd
extends Area2D

@export var life_time := 2.0

var world_pos := Vector2.ZERO
var velocity := Vector2.ZERO
var damage := 1.0

@onready var world := get_tree().current_scene.get_node("World")

func setup_world(spawn_world: Vector2, dir: Vector2, speed: float, dmg: float):
	world_pos = spawn_world
	velocity = dir * speed
	damage = dmg
	rotation = dir.angle()

func _ready():
	$LifeTimer.one_shot = true
	$LifeTimer.wait_time = life_time
	$LifeTimer.timeout.connect(queue_free)
	$LifeTimer.start()
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	world_pos += velocity * delta
	world_pos = world.wrap_offset(world_pos)
	global_position = world.world_to_screen(world_pos)

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
