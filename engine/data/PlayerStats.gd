extends RefCounted
class_name PlayerStats
 
signal change_hp(value, max_value)
signal change_mp(value, max_value)
signal change_sta(value, max_value)

signal change_sed(value, max_value)
signal change_ham(value, max_value)

signal change_gold(value)
signal change_level(value)
signal change_elu(value)
signal change_elv(value)

signal change_spell_slot(slot, name)

var hp:int
var max_hp:int

var mp:int: set = set_mp
var max_mp:int: set = set_max_mp
  
var sta:int: set = set_sta
var max_sta:int: set = set_max_sta

var ham:int: set = set_ham
var max_ham:int: set = set_max_ham

var sed:int: set = set_sed
var max_sed:int: set = set_max_sed

var gold:int: set = set_gold

var level:int: set = set_level
var elu:int: set = set_elu
var elv:int: set = set_elv

var spells:Array

func _init() -> void:
	spells.resize(Global.MAXHECHI)
	spells.fill("(Nada)")

func set_spell(slot:int, text:String) -> void:
	spells[slot] = text
	emit_signal("change_spell_slot", slot, text)

func set_hp(current: int, max: int) -> void:
	hp = current
	max_hp = max
	emit_signal("change_hp", hp, max_hp)
 
func set_mp(value:int) -> void:
	mp	= value
	emit_signal("change_mp", mp, max_mp)
	
func set_max_mp(value:int) -> void:
	max_mp	= value
	emit_signal("change_mp", mp, max_mp)

func set_sta(value:int) -> void:
	sta	= value
	emit_signal("change_sta", sta, max_sta)
	
func set_max_sta(value:int) -> void:
	max_sta	= value
	emit_signal("change_sta", sta, max_sta)
	
func set_ham(value:int) -> void:
	ham	= value
	emit_signal("change_ham", ham, max_ham)
	
func set_max_ham(value:int) -> void:
	max_ham	= value
	emit_signal("change_ham", ham, max_ham)
	
func set_sed(value:int) -> void:
	sed	= value
	emit_signal("change_sed", sed, max_sed)
	
func set_max_sed(value:int) -> void:
	max_sed	= value
	emit_signal("change_sed", sed, max_sed)

func set_gold(value:int) -> void:
	gold = value;
	emit_signal("change_gold", gold)

func set_level(value:int) -> void:
	level = value
	emit_signal("change_level", level)

func set_elu(value:int) -> void:
	elu	= value
	emit_signal("change_elu", elu)
	
func set_elv(value:int) -> void:
	elv	= value
	emit_signal("change_elv", elv) 
