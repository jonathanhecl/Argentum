extends Panel

signal slot_selected

@onready var itemTexture = find_child("ItemTexture")
@onready var quantityLabel = find_child("QuantityLabel")
@onready var equippedLabel = find_child("EquippedLabel")

var item:Item: set = set_item
var quantity:int: set = set_quantity
var equipped:bool: set = set_equipped

var slot_index = -1

func init_item(index:int, new_item:Item, new_quantity:int, new_equipped:bool) -> void:
	self.slot_index = index
	self.item = new_item
	
	if !item:
		new_quantity = 0
	
	self.quantity = new_quantity
	self.equipped = new_equipped
	 
func set_item(new_item:Item) -> void:
	item = new_item
	if !is_inside_tree():
		await self.ready

	if !item:
		itemTexture.texture = null
	else:
		itemTexture.texture = item.texture		
	 
func set_quantity(new_quantity:int) -> void:
	quantity = new_quantity
	if !is_inside_tree():
		await self.ready
	
	if new_quantity <= 1:
		quantityLabel.visible = false
	else:
		quantityLabel.visible = true
		quantityLabel.text = str(quantity)	
	 
func set_equipped(new_value:bool) -> void:
	equipped = new_value
	if !is_inside_tree():
		await self.ready
	equippedLabel.visible = new_value

func _on_ItemSlot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("slot_selected")
