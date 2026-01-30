# res://scripts/Player.gd
extends CharacterBody2D

signal hp_changed(cur, max)
signal exp_changed(exp, exp_to_next, level)
signal died

@export var max_hp := 100.0
@export var move_speed := 260.0
@export var attack := 10.0
@export var attack_speed := 4.0	
@export var pickup_range := 150.0
@export var projectile_count := 1
@export var spread_arc := 15.0

@export var regen_delay := 3.0
@export var regen_per_sec := 6.0

var hp := 100.0
var last_damage_time := 0.0

var level := 1
var current_exp := 0
var exp_to_next := 20

@onready var world := get_tree().current_scene.get_node("World") as Node2D

func _ready():
	hp = max_hp
	global_position = Vector2.ZERO
	emit_signal("hp_changed", hp, max_hp)
	emit_signal("exp_changed", current_exp, exp_to_next, level)
	
	# 播放待机动画
	$AnimatedSprite2D.play("idle")

func _process(delta):
	# look_at(get_global_mouse_position()) # 移除角色跟随鼠标旋转
	_handle_regen(delta)

func _physics_process(delta):
	var dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	(world as Node).add_offset(dir * move_speed * delta)
	global_position = Vector2.ZERO # 居中

func _handle_regen(delta):
	if hp <= 0: return
	var t := Time.get_ticks_msec() / 1000.0
	if t - last_damage_time >= regen_delay and hp < max_hp:
		hp = min(max_hp, hp + regen_per_sec * delta)
		emit_signal("hp_changed", hp, max_hp)

func take_damage(amount: float):
	if hp <= 0: return

	# 无敌帧判定 (1.0秒)
	var time_now := Time.get_ticks_msec() / 1000.0
	if time_now - last_damage_time < 1.0:
		return

	hp -= amount
	last_damage_time = time_now
	emit_signal("hp_changed", hp, max_hp)
	if hp <= 0:
		$AnimatedSprite2D.play("die")
		set_physics_process(false) # 禁用移动
		set_process(false)         # 禁用瞄准/其他每帧逻辑
		emit_signal("died")

func add_exp(amount: int):
	current_exp += amount
	while current_exp >= exp_to_next:
		current_exp -= exp_to_next
		_level_up()
	emit_signal("exp_changed", current_exp, exp_to_next, level)

func _level_up():
	level += 1
	exp_to_next = int(exp_to_next * 1.35 + 5)
	Events.emit_level_up(level)
