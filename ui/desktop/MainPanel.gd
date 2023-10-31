extends VBoxContainer
@onready var _player_hp = find_child("UserHP")
@onready var _player_mp = find_child("UserMP")
@onready var _player_sta = find_child("UserSTA")
@onready var _player_sed = find_child("UserSed")
@onready var _player_ham = find_child("UserHam")

@onready var _inventory_container = find_child("InventoryContainer")
@onready var _spell_container = find_child("SpellsContainer")

func initialize(stats:PlayerStats, inventory:Inventory, protocol:GameProtocol) -> void:
	_inventory_container.set_inventory(inventory)
	_spell_container.initialize(stats, protocol) 
	   
	stats.connect("change_hp", Callable(self, "_on_change_hp"))
	stats.connect("change_mp", Callable(self, "_on_change_mp"))
	stats.connect("change_ham", Callable(self, "_on_change_ham"))
	stats.connect("change_sed", Callable(self, "_on_change_sed"))
	stats.connect("change_sta", Callable(self, "_on_change_sta"))
	
func _on_change_mp(value:int, max_value:int) -> void:
	_player_mp.value = value
	_player_mp.max_value = max_value
	
func _on_change_ham(value:int, max_value:int) -> void:
	_player_ham.text = "hambre:\n%d/%d" % [value, max_value] 

func _on_change_sed(value:int, max_value:int) -> void:
	_player_sed.text = "sed:\n%d/%d" % [value, max_value] 
	
func _on_change_sta(value:int, max_value:int) -> void:
	_player_sta.value = value
	_player_sta.max_value = max_value

func _on_change_hp(value:int, max_value:int) -> void:
	_player_hp.value = value
	_player_hp.max_value = max_value
