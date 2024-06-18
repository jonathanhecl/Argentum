extends Node

@export var initial_scene_desktop: PackedScene
@export var initial_scene_mobile: PackedScene

@export var server_list: ItemList
@export var server_confirm: Button
@export var server_automatic: CheckBox

const URL_SERVER_LIST = "https://raw.githubusercontent.com/jonathanhecl/Argentum/main/servers.json"

var http_request = HTTPRequest.new()

var current_scene:Node = null
var _protocol:GameProtocol = null

var count: int = 5

var list:Variant

func _ready():	
	add_child(http_request)
	http_request.request_completed.connect(_load_server_list)
	var err = http_request.request(str(URL_SERVER_LIST, "?", randi()))
	if err != OK:
		print(err)
		list = [{"title": "localhost", "host": "localhost", "port": 7666}]
		show_server_list()
	
	get_tree().create_timer(1).timeout.connect(_timer_count)
	
	_protocol = GameProtocol.new()
	Connection.connect("message_received", Callable(self, "_on_message_received"))

func switch_scene(scene):
	if current_scene:
		current_scene.queue_free()
	
	current_scene = scene
	add_child(scene)

func _on_message_received(data):
	_protocol.handle_incoming_data(data)

func _load_server_list(result, response_code, headers, body):
	var json = JSON.new()
	var err = json.parse(body.get_string_from_utf8())

	list = json.get_data()
	show_server_list()
	
func show_server_list():
	for o in list:
		server_list.add_item(o.title)
		
	if server_list.item_count>0:
		server_list.select(0)
		server_list.grab_focus()

func _on_item_list_gui_input(event: InputEvent) -> void:
	if server_automatic.button_pressed:
		server_automatic.button_pressed = false
	if event.is_action_pressed("ui_accept"):
		server_confirm.grab_focus()
		
func _timer_count():
	if server_automatic.button_pressed:
		server_automatic.text = "Automatico (" + str(count) + "s)"
		count = count - 1
		if count == 0:
			_on_button_pressed()
			return
			
	get_tree().create_timer(1).timeout.connect(_timer_count)
	
func _on_button_pressed() -> void:
	if len(server_list.get_selected_items())>0:
		print(list[server_list.get_selected_items()[0]])
		await get_tree().create_timer(1).timeout
		go_to_lobby()
		
func go_to_lobby():
	var scene: Node	
		
	match OS.get_name():
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD", "Web":
			Configuration.interface_mode = 1
		"Android", "iOS":
			Configuration.interface_mode = 0
	
	if Configuration.interface_mode == 0:
		ProjectSettings.set_setting("display/window/size/resizable", false)
		scene = initial_scene_mobile.instantiate()
	else:
		ProjectSettings.set_setting("display/window/size/resizable", true)
		scene = initial_scene_desktop.instantiate()
		
		scene._protocol = _protocol
		switch_scene(scene)
