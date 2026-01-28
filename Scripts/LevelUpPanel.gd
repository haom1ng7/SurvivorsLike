# res://scripts/UI_LevelUp.gd
extends Control
signal picked(id: String)

@onready var btn_a := $OptionA
@onready var btn_b := $OptionB
@onready var title := $Title

var options := []

func _ready():
	hide()
	# 暂停时 UI 还要能点
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	btn_a.pressed.connect(func(): _pick(0))
	btn_b.pressed.connect(func(): _pick(1))

func open(level: int, candidates: Array):
	options = candidates
	title.text = "升级！选择一件藏品（Lv.%d）" % level
	btn_a.text = "%s\n%s" % [options[0].name, options[0].desc]
	btn_b.text = "%s\n%s" % [options[1].name, options[1].desc]
	show()
	get_tree().paused = true

func _pick(idx: int):
	hide()
	get_tree().paused = false
	picked.emit(options[idx].id)
