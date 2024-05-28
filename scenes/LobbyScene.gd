extends Node

@export var create_scene_mobile: PackedScene  
@export var game_scene_mobile: PackedScene  
@export var create_scene_desktop: PackedScene  
@export var game_scene_desktop: PackedScene 

enum State{
	None,
	Login,
	Create	
}
 
@export var server_ip: LineEdit
@export var server_port: LineEdit
@export var music_active: Button
 
@onready var user_name:LineEdit = find_child("UserName")
@onready var user_password:LineEdit = find_child("UserPassword")
 
var _protocol:GameProtocol = null
var current_state:int = State.None

func _ready(): 
	Connection.connect("connected", Callable(self, "_on_client_connected"))
	Connection.connect("disconnected", Callable(self, "_on_client_disconnected"))

	_protocol.connect("logged", Callable(self, "_on_client_logged"))
	_protocol.connect("error_message", Callable(self, "_on_error_message")) 

func _on_BtnExit_pressed():
	get_tree().quit()
 
func _on_BtnConnect_pressed():
	if(current_state != State.None): return
	
	Configuration.server_ip = server_ip.text
	Configuration.server_port = server_port.text.to_int()
	Configuration.music = music_active.button_pressed
	
	current_state = State.Login
	Connection.connect_to_server()

func _on_BtnCreate_pressed():
	if(current_state != State.None): return
	
	Configuration.server_ip = server_ip.text
	Configuration.server_port = server_port.text.to_int()
	Configuration.music = music_active.button_pressed
	
	current_state = State.Create
	Connection.connect_to_server()

func _on_client_connected():
	if(current_state == State.Create):
		var scene = create_scene_mobile.instantiate()
		
		scene.initialize(_protocol)
		get_parent().switch_scene(scene)
	else:
		_protocol.write_login_existing_char(user_name.text, user_password.text)
		_protocol.flush_data()

	print("conexion establecida ", current_state)

func _on_client_disconnected():
	current_state = State.None
 
func _on_client_logged():
	var scene = game_scene_mobile.instantiate()
	scene.initialize(_protocol)
	
	get_parent().switch_scene(scene)

func _on_error_message(message:String):
	$LabelError.text = message
	print(message) 
