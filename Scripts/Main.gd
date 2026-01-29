# res://scripts/Main.gd
extends Node2D

@export var shard_scene: PackedScene
@export var death_scene: PackedScene

@onready var enemies := $World/Entities/Enemies
@onready var drops := $World/Entities/Drops
@onready var player := $World/Entities/Player
@onready var game_state := $Systems/GameState
@onready var relics := $Systems/Relics
@onready var hud := $UI/HUD
@onready var level_up_panel := $UI/LevelUpPanel

func _ready():
	# HUD 绑定
	hud.bind(player, game_state)

	# 计时开始
	game_state.start_game()

	# 敌人生成时绑定死亡事件
	enemies.child_entered_tree.connect(_on_enemy_spawned)

	# 升级
	Events.level_up.connect(_on_level_up)
	level_up_panel.picked.connect(_on_relic_picked)
	
	# 连接玩家死亡信号
	player.died.connect(_on_player_died) 

func _on_enemy_spawned(n: Node):
	if n.has_signal("died"):
		n.died.connect(_on_enemy_died)

func _on_enemy_died(enemy_world_pos: Vector2):
	# 掉一个碎片
	var s := shard_scene.instantiate()
	drops.add_child(s)
	s.setup_world(enemy_world_pos + Vector2(randf_range(-12, 12), randf_range(-12, 12)))

func _on_level_up(level: int):
	var cands :Array = relics.roll_two()
	level_up_panel.open(level, cands)

func _on_relic_picked(id: String):
	relics.apply_relic(id, player)

func _on_player_died():
	get_tree().change_scene_to_packed(death_scene)
