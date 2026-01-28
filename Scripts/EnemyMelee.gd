# res://scripts/EnemyMelee.gd
extends "res://scripts/EnemyBase.gd"

@export var contact_damage := 8.0
var can_hit := true

func _ready():
	super._ready()
	$HitArea.body_entered.connect(_on_hit)
	$HitCooldown.timeout.connect(func(): can_hit = true)

func _physics_process(delta):
	if target == null:
		return

	var player_world := world.world_offset
	var to_player := player_world - world_pos
	to_player.x = world.wrap_nearest(to_player.x, world.world_size.x)
	to_player.y = world.wrap_nearest(to_player.y, world.world_size.y)

	var dir := to_player.normalized()
	world_pos += dir * move_speed * delta
	wrap_world_pos()
	update_screen_pos()

func _on_hit(body):
	if not can_hit: return
	if body.has_method("take_damage"):
		body.take_damage(contact_damage)
		can_hit = false
		$HitCooldown.start()
