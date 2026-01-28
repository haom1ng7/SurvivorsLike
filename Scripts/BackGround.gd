extends Sprite2D

@export var tile_size: Vector2 = Vector2(1024, 1024) # 背景尺寸

@onready var world: World = get_tree().current_scene.get_node("World") as World

func _process(_delta: float) -> void:
	# 让背景随世界反向滚动，并取模实现无缝循环
	var ofs: Vector2 = world.world_offset
	position = Vector2(-fposmod(ofs.x, tile_size.x), -fposmod(ofs.y, tile_size.y))
