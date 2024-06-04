extends Node

signal connected
signal disconnected
signal message_received(data)

var _client = StreamPeerTCP.new()
var _connected = false

func _ready():
	_client.set_no_delay(true)

func _process(_delta): 
	process_connection()

func disconnect_from_server():
	print("disconnect_from_server")
	_client.disconnect_from_host()
	
func connect_to_server() -> Error:
	var err = _client.connect_to_host(Configuration.server_ip, Configuration.server_port)
	print("connect_to_server: ", err, "-", _client.get_status(), " (", Configuration.server_ip, ":", Configuration.server_port, ")")
	return err

func process_connection():
	await get_tree().create_timer(0.1).timeout
	_client.poll()
	if _client.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		print("connecting...") # await
	elif _client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		if !_connected:
			_connected = true
			emit_signal("connected")
		poll_server()
	elif (_client.get_status() == StreamPeerTCP.STATUS_NONE || 
		_client.get_status() == StreamPeerTCP.STATUS_ERROR):
		if _connected:
			_connected = false
			emit_signal("disconnected")

func send_data(data):
	if _connected:
		var array = PackedByteArray(data)
		print_debug("Sended msg: " + str(data))
		var error = _client.put_data(data)
		if error != 0:
			print_debug("Error on packet put: %s" % error)

func poll_server():	
	var message = _client.get_data(_client.get_available_bytes())
	if len(message[1]) > 0:
		var msg: PackedByteArray = message[1]
		print_debug("Received msg: " + str(msg))
		emit_signal("message_received", msg) 
