# res://scripts/Bullet.gd
extends Area2D

@export var life_time := 2.0

var world_pos := Vector2.ZERO
var velocity := Vector2.ZERO
var damage := 1.0
var pierce_count := 1
var is_enemy := false

@onready var world := get_tree().current_scene.get_node("World")

func setup_world(spawn_world: Vector2, dir: Vector2, speed: float, dmg: float, pierce: int = 1, _is_enemy: bool = false):
	world_pos = spawn_world
	velocity = dir * speed
	damage = dmg
	pierce_count = pierce
	is_enemy = _is_enemy
	rotation = dir.angle()
	
	if world != null:
		global_position = world.world_to_screen(world_pos)

func _ready():
	$LifeTimer.one_shot = true
	$LifeTimer.wait_time = life_time
	$LifeTimer.timeout.connect(queue_free)
	$LifeTimer.start()
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	world_pos += velocity * delta
	world_pos = world.wrap_offset(world_pos)
	global_position = world.world_to_screen(world_pos)

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		pierce_count -= 1
		if pierce_count <= 0:
			queue_free()
	else:
		queue_free()

func _on_area_entered(area):
	# 子弹抵消逻辑: 必须是 Bullet 脚本，且阵营不同
	if area.get_script() == get_script():
		if is_enemy != area.is_enemy:
			queue_free()

