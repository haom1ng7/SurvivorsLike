# res://scripts/GameState.gd
extends Node
signal time_changed(left_sec: int)
signal game_over(win: bool)

@export var match_duration_sec := 7 * 60

var t_left := 0.0
var running := false
var _emit_acc := 0.0

func start_game():
	t_left = float(match_duration_sec)
	running = true
	time_changed.emit(int(ceil(t_left)))

func _process(delta):
	if not running: return
	t_left = max(0.0, t_left - delta)

	_emit_acc += delta
	if _emit_acc >= 0.2: # HUD 不用每帧刷新
		_emit_acc = 0.0
		time_changed.emit(int(ceil(t_left)))

	if t_left <= 0.0:
		running = false
		game_over.emit(true)
