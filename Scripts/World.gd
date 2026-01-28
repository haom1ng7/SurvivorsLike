# res://scripts/World.gd
class_name World
extends Node2D

@export var world_size := Vector2(4000, 4000)
var world_offset := Vector2.ZERO

func add_offset(delta: Vector2) -> void:
	world_offset += delta
	world_offset = wrap_offset(world_offset)

func wrap_offset(ofs: Vector2) -> Vector2:
	return Vector2(fposmod(ofs.x, world_size.x), fposmod(ofs.y, world_size.y))

func wrap_nearest(v: float, size: float) -> float:
	if v >  size * 0.5: v -= size
	if v < -size * 0.5: v += size
	return v

func world_to_screen(world_pos: Vector2) -> Vector2:
	# 把世界坐标映射为“玩家居中”的屏幕相对坐标
	var p := world_pos - world_offset
	p.x = wrap_nearest(p.x, world_size.x)
	p.y = wrap_nearest(p.y, world_size.y)
	return p

func screen_to_world(screen_pos: Vector2) -> Vector2:
	# 屏幕相对坐标 -> 世界坐标
	var p := world_offset + screen_pos
	return wrap_offset(p)
