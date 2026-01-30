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
	if has_node("Sprite2D") and get_node("Sprite2D") is AnimatedSprite2D:
		# 兼容改了名字叫 AnimatedSprite2D 或者没改名的情况
		(get_node("Sprite2D") as AnimatedSprite2D).play("idle")
	elif has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("idle")

func set_target(t: Node2D) -> void:
	target = t

func take_damage(amount: float):
	hp -= amount
	if hp <= 0:
		died.emit(world_pos)
		
		# 播放死亡动画逻辑
		set_physics_process(false) # 停止移动
		if has_node("CollisionShape2D"): $CollisionShape2D.call_deferred("set_disabled", true) # 禁用碰撞
		
		var anim: AnimatedSprite2D = null
		if has_node("Sprite2D") and get_node("Sprite2D") is AnimatedSprite2D:
			anim = get_node("Sprite2D")
		elif has_node("AnimatedSprite2D"):
			anim = get_node("AnimatedSprite2D")
			
		if anim:
			anim.play("die")
			await anim.animation_finished
			
		queue_free()

func wrap_world_pos():
	world_pos = world.wrap_offset(world_pos)

func update_screen_pos():
	global_position = world.world_to_screen(world_pos)
