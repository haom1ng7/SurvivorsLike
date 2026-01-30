# res://scripts/Relics.gd
extends Node

var relics : Dictionary = {
	"atk_up": {name="锋刃碎片", desc="攻击力 +20%", apply=func(p): p.attack *= 1.2},
	"spd_up": {name="疾行刻印", desc="移动速度 +15%", apply=func(p): p.move_speed *= 1.15},
	"as_up":  {name="连发机芯", desc="攻速 +25%", apply=func(p): p.attack_speed *= 1.25},
	"hp_up":  {name="血契护符", desc="最大生命 +1", apply=func(p): p.max_hp += 1; p.hp += 1},
	"regen":  {name="自愈纹章", desc="回盾速度 +20%", apply=func(p): p.regen_time_needed *= 0.8},
	"double_shot": {name="双重镜像", desc="投射物数量 +1, 伤害 -10%", apply=func(p): p.projectile_count += 1; p.attack *= 0.9},
	"shotgun": {name="散射棱镜", desc="投射物数量 +2, 散布变大", apply=func(p): p.projectile_count += 2; p.spread_arc += 15.0; p.attack *= 0.8},
}

func roll_two() -> Array:
	var keys := relics.keys()
	keys.shuffle()
	var a: String = String(keys[0])
	var b: String = String(keys[1])
	return [
		{"id": a, "name": relics[a]["name"], "desc": relics[a]["desc"]},
		{"id": b, "name": relics[b]["name"], "desc": relics[b]["desc"]},
	]

func apply_relic(id: String, player):
	relics[id].apply.call(player)
