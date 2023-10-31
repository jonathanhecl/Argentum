extends PanelContainer

var slot_index = -1
var spell_name = "": set = _set_spell_name

func _set_spell_name(spell_name:String) -> void:
	if !is_inside_tree():
		await self.ready
		
	$NameLabel.text = spell_name
