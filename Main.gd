extends Node

@export var initial_scene_desktop: PackedScene
@export var initial_scene_mobile: PackedScene

var current_scene:Node = null
var _protocol:GameProtocol = null

func _ready():
	Connection.connect("message_received", Callable(self, "_on_message_received"))
	var scene: Node
	
	match OS.get_name():
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD", "Web":
			Configuration.interface_mode = 1
		"Android", "iOS":
			Configuration.interface_mode = 0
	Configuration.interface_mode = 0
	
	if Configuration.interface_mode == 0:
		ProjectSettings.set_setting("display/window/size/resizable", false)
		scene = initial_scene_mobile.instantiate()
	else:
		ProjectSettings.set_setting("display/window/size/resizable", true)
		scene = initial_scene_desktop.instantiate()
		
	_protocol = GameProtocol.new()

	scene._protocol = _protocol
	switch_scene(scene)

func switch_scene(scene):
	if current_scene:
		current_scene.queue_free()
	
	current_scene = scene
	add_child(scene)

func _on_message_received(data):
	_protocol.handle_incoming_data(data)
