extends Node

var grh_data = []
var bodies_data = {}
var heads_data = {}
var helmets_data = {}
var weapons_data = {}
var shields_data = {}
var fxs_data = {}

const NUMATRIBUTES = 5
const MAX_INVENTORY_OBJS = 10000
const MAX_INVENTORY_SLOTS = 20
const MAX_NPC_INVENTORY_SLOTS = 50
const MAXHECHI = 35
const MAXSKILLPOINTS = 100
const NUMCIUDADES = 5
const NUMSKILLS = 21
const NUMATRIBUTOS = 5
const NUMCLASES = 16
const NUMRAZAS = 5
const TILE_SIZE = 32

const MAP_WIDTH = 100
const MAP_HEIGHT = 100

const NO_ANIMAR = 2

enum eClass{
	Mage = 1 ,   #Mago
	Cleric,      #Clérigo
	Warrior,     #Guerrero
	Assasin,     #Asesino
	Thief  ,     #Ladrón
	Bard   ,     #Bardo
	Druid  ,     #Druida
	Bandit ,     #Bandido
	Paladin ,    #Paladín
	Hunter  ,    #Cazador
	Fisher   ,   #Pescador
	Blacksmith,  #Herrero
	Lumberjack,  #Leñador
	Miner     ,  #Minero
	Carpenter ,  #Carpintero
	Pirat    ,   #Pirata
}

enum eCiudad{
	cUllathorpe = 1,
	cNix,
	cBanderbill,
	cLindos,
	cArghal,
}

enum Heading{
	Up = 1,
	Right,
	Down,
	Left
}

enum eRaza{
	Humano = 1,
	Elfo,
	ElfoOscuro,
	Gnomo,
	Enano,
 }
 
enum eSkill{
	Suerte = 1,
	Magia = 2,
	Robar = 3,
	Tacticas = 4,
	Armas = 5,
	Meditar = 6,
	Apunalar = 7,
	Ocultarse = 8,
	Supervivencia = 9,
	Talar = 10,
	Comerciar = 11,
	Defensa = 12,
	Pesca = 13,
	Mineria = 14,
	Carpinteria = 15,
	Herreria = 16,
	Liderazgo = 17,
	Domar = 18,
	Proyectiles = 19,
	Wrestling = 20,
	Navegacion = 21,
}

enum eAtributos{
	Fuerza = 1,
	Agilidad = 2,
	Inteligencia = 3,
	Carisma = 4,
	Constitucion = 5,
}

enum eGenero{
	Hombre = 1,
	Mujer,
}

enum PlayerType {
	None = 0 ,
	User = 1 << 1,
	Consejero = 1 << 2,
	SemiDios = 1 << 3,
	Dios = 1 << 4,
	Admin = 1 << 5,
	RoleMaster = 1 << 6,
	ChaosCouncil = 1 << 7,
	RoyalCouncil = 1 << 8,
}



const ClassNames = {
	eClass.Paladin : "Paladin",
	eClass.Mage : "Mago",
	eClass.Warrior : "Guerreo",
	eClass.Assasin : "Asesino",
	eClass.Thief : "Ladron",
	eClass.Bard : "Bardo",
	eClass.Druid : "Druido",
	eClass.Bandit : "Bandido",
	eClass.Hunter : "Cazador",
	eClass.Fisher : "Pescador",
	eClass.Lumberjack : "Talador",
	eClass.Blacksmith : "Herrero",
	eClass.Miner : "Minero",
	eClass.Carpenter : "Carpintero",
	eClass.Pirat : "Pirata", 
	eClass.Cleric : "Clerigo"
}

const GenderNames = {
	eGenero.Hombre : "Hombre",
	eGenero.Mujer : "Mujer"
}

const RaceNames = {
	eRaza.Elfo : "Elfo",
	eRaza.Gnomo : "Gnomo",
	eRaza.Enano : "Enano",
	eRaza.Humano : "Humano",
	eRaza.ElfoOscuro : "Elfo Drow"
}

const HomeNames = {
	eCiudad.cUllathorpe : "Ullathorpe",
	eCiudad.cNix : "Nix",
	eCiudad.cBanderbill : "Banderbill",
	eCiudad.cLindos : "Lindos",
	eCiudad.cArghal : "Arghâl"
}
 
class GrhData:
	var region = Rect2()
	var file_num  = 0
	var num_frames = 0
	var frames = []
	var speed = 0.0

func _ready():
	_load_grh_data() 
	_load_ao_resources()
	
func load_json_from_file(filename:String):
	# Godot 3
	# var file = File.new()
	# file.open(filename, file.READ)
	var file = FileAccess.open(filename, FileAccess.READ)
	
	var json = file.get_as_text()
	var test_json_conv = JSON.new()
	# Godot 3 test_json_conv.parse(json).result
	test_json_conv.parse(json)
	var json_result = test_json_conv.get_data()
	
	file.close()
	return json_result

func _load_ao_resources():
	pass
		
func _load_grh_data():
	# Godot 3
	# var file = File.new()
	# file.open("res://assets/init/graficos.ind", File.READ)
	var file = FileAccess.open("res://assets/init/graficos.ind", FileAccess.READ)
	
	var content = file.get_buffer(file.get_length())
	var buffer = StreamPeerBuffer.new()
	
	buffer.data_array = content
	
	var size = buffer.get_32()
	
	var _grh_count = buffer.get_32()
	grh_data.resize(_grh_count + 1)
	grh_data.fill(GrhData.new())
	
	while(buffer.get_position() < buffer.get_size()):
		var grh_id = buffer.get_32()
		var grh = GrhData.new()
		
		
		grh.num_frames = buffer.get_16()
		grh.frames = []
		for _i in range(grh.num_frames + 1):
			grh.frames.append(0)
		
		if grh.num_frames > 1:
			for i in range(1, grh.num_frames + 1):
				grh.frames[i] = buffer.get_32()
			
			grh.speed  = buffer.get_float()
			grh.region = grh_data[grh.frames[1]].region
		else:
			grh.file_num = buffer.get_32()
			grh.frames[1] = grh_id
			
			grh.region = Rect2(0, 0, 0, 0)
			grh.region.position.x = buffer.get_16()
			grh.region.position.y = buffer.get_16()
			
			grh.region.size.x = buffer.get_16()
			grh.region.size.y = buffer.get_16()
		
		grh_data[grh_id] = grh    
	
func heading_to_vector(heading:int) -> Vector2:
	match heading:
		Heading.Left:
			return Vector2.LEFT
		Heading.Right:
			return Vector2.RIGHT
		Heading.Up:
			return Vector2.UP
		Heading.Down:
			return Vector2.DOWN
	
	print("heading con una valor invalido")
	return Vector2.ZERO

func load_texture_from_id(id:int)-> Texture2D:
	return load("res://assets/graphics/%d.png" % id) as Texture2D
 
