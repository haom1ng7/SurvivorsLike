# res://scripts/UI_HUD.gd
extends Control
@onready var hp_label := $HPLabel
@onready var exp_label := $EXPLabel
@onready var time_label := $TimeLabel

func bind(player, game_state):
	player.hp_changed.connect(func(cur, maxv):
		hp_label.text = "HP: %d/%d" % [int(cur), int(maxv)]
	)
	player.exp_changed.connect(func(e, need, lv):
		exp_label.text = "Lv.%d  EXP: %d/%d" % [lv, e, need]
	)
	game_state.time_changed.connect(func(left):
		var m :int = left / 60
		var s :int = left % 60
		time_label.text = "%02d:%02d" % [m, s]
	)
