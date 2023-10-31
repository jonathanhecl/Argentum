extends Node

signal connected
signal disconnected
signal message_received(data)
 
#const websocket_url = "ws://%s:%d"

#Godot 3 var _client = WebSocketClient.new()
var _client = StreamPeerTCP.new()
var _wrapped_client

func _ready():
	_client.set_no_delay(true)	
#	_client.connect("connection_closed", Callable(self, "_closed"))
#	_client.connect("connection_error", Callable(self, "_closed"))
#	_client.connect("connection_established", Callable(self, "_connected"))
#
#	_client.connect("data_received", Callable(self, "_on_data"))
  
#func _closed(was_clean = false): 
#	print("Closed, clean: ", was_clean) 
#	emit_signal("disconnected")
#
#func _connected(proto = ""): 
#	print("Connected with protocol: ", proto)
#	emit_signal("connected") 
#
#func _on_data(): 
#	var data = _client.get_peer(1).get_packet()
#	emit_signal("message_received", data) 

func _process(_delta): 
	#_client.poll()
	if _client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		emit_signal("connected") 
		poll_server()
	elif _client.get_status() == StreamPeerTCP.STATUS_ERROR:
		emit_signal("disconnected")

func disconnect_from_server():
	_client.disconnect_from_host()
	
func connect_to_server(ip, port):
	#return _client.connect_to_url(websocket_url % [ip, port])
	_client.connect_to_host(ip, port)
	if _client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		_wrapped_client = PacketPeerStream.new()
		_wrapped_client.set_stream_peer(_client)

func send_data(data):
	#_client.get_peer(1).put_packet(data)
	if _client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		_wrapped_client.put_var(data)
		var error = _wrapped_client.get_packet_error()
		if error != 0:
			print_debug("Error on packet put: %s" % error)

func poll_server():	
	while _wrapped_client.get_available_packet_count() > 0:
		var msg = _wrapped_client.get_var()
		var error = _wrapped_client.get_packet_error()
		if error != 0:
			print_debug("Error on packet get: %s" % error)
		if msg == null:
			continue;
		print_debug("Received msg: " + str(msg))
		emit_signal("message_received", msg) 
