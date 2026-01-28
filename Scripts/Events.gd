# res://scripts/Events.gd
extends Node

signal level_up(level: int)

func emit_level_up(level: int) -> void:
	level_up.emit(level)
