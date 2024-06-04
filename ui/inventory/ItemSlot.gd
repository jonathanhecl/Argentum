extends PanelContainer
class_name ItemSlot

signal item_selected

@onready var quantityLabel = find_child("QuantityLabel")
@onready var equippedLabel = find_child("EquippedLabel")
@onready var selectedLabel = find_child("SelectedLabel")
@onready var iconTexture = find_child("IconTexture")

@export_range(-1, 1000, 1) var inventory_index: int = -1

var item:Item = null: set = _set_item
var quantity:int = 0: set = _set_quantity
var equipped:bool = false: set = _set_equipped

func set_item(index:int, item:Item, quantity:int, equipped:bool) -> void:
	self.inventory_index = index
	self.item = item
	
	if not item:
		quantity = 0
	
	self.quantity = quantity
	self.equipped = equipped

func _set_item(new_item:Item) -> void:
	item = new_item
	
	if not is_inside_tree():
		await self.ready
		
	if not item:
		iconTexture.texture = null
	else:
		iconTexture.texture = item.texture
		
func _set_quantity(new_quantity:int) -> void:
	quantity = new_quantity

	if not is_inside_tree():
		await self.ready
	
	if quantity <= 1:
		quantityLabel.visible = false
	else:
		quantityLabel.visible = true
		quantityLabel.text = str(quantity)

func _set_equipped(new_equipped:bool) -> void:
	equipped = new_equipped
	
	if not is_inside_tree():
		await self.ready
	
	if equipped:
		equippedLabel.visible = true
	else:
		equippedLabel.visible = false 

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			emit_signal("item_selected")
			if selectedLabel.visible:
				selectedLabel.visible = false
			else: 
				selectedLabel.visible = true
