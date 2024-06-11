extends HBoxContainer

@onready var _spellContainer = find_child("SpellContainerMobile")
@onready var _inventoryContainer = find_child("InventoryContainerMobile")
@onready var _ntnSwitchPanel = find_child("BtnSwitchPanel")

const _spellTexture = preload("res://assets/graphics/531.png")
const _inventoryTexture = preload("res://assets/graphics/572.png")

@onready var _barHP = find_child("StatsBarHP")
@onready var _barMP = find_child("StatsBarMP")
@onready var _barSTA = find_child("StatsBarSTA")
@onready var _barSED = find_child("StatsBarSED")
@onready var _barHAM = find_child("StatsBarHAM")
@onready var _goldLabel = find_child("GoldLabel")

func initialize(player_data:PlayerData, protocol:GameProtocol) -> void:
	_spellContainer.intialize(player_data.stats, protocol)
	_inventoryContainer.initialize(player_data, protocol)
	
	var stats = player_data.stats
	
	stats.connect("change_hp", Callable(self, "_on_change_hp"))
	stats.connect("change_mp", Callable(self, "_on_change_mp"))
	stats.connect("change_sta", Callable(self, "_on_change_sta"))
	stats.connect("change_ham", Callable(self, "_on_change_ham"))
	stats.connect("change_sed", Callable(self, "_on_change_sed"))
	stats.connect("change_gold", Callable(self, "_on_change_gold"))
 
func _on_BtnSwitchPanel_pressed() -> void:
	if _spellContainer.visible:
		_inventoryContainer.visible = true
		_spellContainer.visible = false
		_ntnSwitchPanel.texture_normal = _spellTexture
	else:
		_inventoryContainer.visible = false
		_spellContainer.visible = true 
		_ntnSwitchPanel.texture_normal = _inventoryTexture
		
func _on_change_hp(value:int, max_value:int) -> void:
	_barHP.max_value = max_value
	_barHP.value = value
	
func _on_change_mp(value:int, max_value:int) -> void:
	_barMP.max_value = max_value
	_barMP.value = value
	
func _on_change_sta(value:int, max_value:int) -> void:
	_barSTA.max_value = max_value
	_barSTA.value = value
	
func _on_change_ham(value:int, max_value:int) -> void:
	_barHAM.max_value = max_value
	_barHAM.value = value
	
func _on_change_sed(value:int, max_value:int) -> void:
	_barSED.max_value = max_value
	_barSED.value = value
	
func _on_change_gold(value:int) -> void:
	_goldLabel.text = str(value)
