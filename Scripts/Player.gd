# res://scripts/Player.gd
extends CharacterBody2D

signal hp_changed(cur, max)
signal exp_changed(exp, exp_to_next, level)
signal died

@export var max_hp := 3.0 # 改为个位数层数
@export var move_speed := 260.0
@export var attack := 10.0
@export var attack_speed := 4.0
@export var pickup_range := 150.0
@export var projectile_count := 1
@export var spread_arc := 15.0

@export var regen_delay := 5.0 # 受伤后回盾冷却
@export var regen_time_needed := 3.0 # 每回复一层需要的时间

var hp := 3.0
var last_damage_time := 0.0
var regen_acc := 0.0 # 回血累积计时器

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
	_update_shield_visual(hp, hp)

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
	if hp <= 0 or hp >= max_hp: 
		regen_acc = 0.0
		return
		
	var t := Time.get_ticks_msec() / 1000.0
	if t - last_damage_time >= regen_delay:
		regen_acc += delta
		if regen_acc >= regen_time_needed:
			regen_acc = 0.0
			var old_hp := hp
			hp += 1.0
			# 播放护盾恢复动画
			emit_signal("hp_changed", hp, max_hp)
			_update_shield_visual(hp, old_hp)

func take_damage(_amount: float): # 忽略传入伤害值，固定扣1
	if hp <= 0: return

	# 无敌帧判定 (1.0秒)
	var time_now := Time.get_ticks_msec() / 1000.0
	if time_now - last_damage_time < 1.0:
		return
	
	var old_hp := hp
	hp -= 1.0 # 每次爆一层
	last_damage_time = time_now
	regen_acc = 0.0 # 重置回血计时
	
	emit_signal("hp_changed", hp, max_hp)
	_update_shield_visual(hp, old_hp)
	
	if hp <= 0:
		$AnimatedSprite2D.play("die")
		if has_node("ShieldSprite"): $ShieldSprite.visible = false # 死亡隐藏护盾
		set_physics_process(false) # 禁用移动
		set_process(false)         # 禁用瞄准/其他每帧逻辑
		emit_signal("died")

func _update_shield_visual(current: float, old: float):
	if not has_node("ShieldSprite"): return
	var s := get_node("ShieldSprite") as AnimatedSprite2D
	
	if current < old:
		# 受伤
		if current <= 0:
			s.play("destroyed")
		else:
			s.play("damaged")
			# 播放完受击动画后，恢复到对应血量的静态帧（暂时简化）
			await s.animation_finished
			_show_static_shield(s, current)
	elif current > old:
		# 回血
		s.play("regained")
		await s.animation_finished
		_show_static_shield(s, current)
	else:
		# 初始化
		_show_static_shield(s, current)

func _show_static_shield(s: AnimatedSprite2D, val: float):
	# 根据血量不同状态显示
	if val >= 3:
		s.play("3_hp")
	elif val == 2:
		s.play("2_hp")
	elif val == 1:
		s.play("1_hp")
	else:
		s.play("destroyed") # 隐藏
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
