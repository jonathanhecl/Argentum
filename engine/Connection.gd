extends Node

signal connected
signal disconnected
signal message_received(data)
 
const websocket_url = "ws://%s:%d"

#var _client = WebSocketClient.new()
var _client = null

func _ready():
#	_client.connect("connection_closed", Callable(self, "_closed"))
#	_client.connect("connection_error", Callable(self, "_closed"))
#	_client.connect("connection_established", Callable(self, "_connected"))
#
#	_client.connect("data_received", Callable(self, "_on_data"))
	pass
  
func _closed(was_clean = false): 
	print("Closed, clean: ", was_clean) 
	emit_signal("disconnected")
 
func _connected(proto = ""): 
	print("Connected with protocol: ", proto)
	emit_signal("connected") 

func _on_data(): 
	var data = _client.get_peer(1).get_packet()
	emit_signal("message_received", data) 

func _process(_delta): 
	#_client.poll()
	pass

func disconnect_from_server():
	_client.disconnect_from_host()
	
func connect_to_server(ip, port):
	return _client.connect_to_url(websocket_url % [ip, port])

func send_data(data):
	_client.get_peer(1).put_packet(data)
