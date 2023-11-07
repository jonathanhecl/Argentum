extends Node2D
class_name ArgentumTileMap

const MAP_WIDTH  = 100
const MAP_HEIGHT = 100
const TILE_SIZE  = 32

const TEXTURE_PATH = "res://assets/graphics/%d.png"

var _texture_cache:Dictionary
var _tiles:Array[Tile]

class Tile:
	var texture:Texture2D
	var region:Rect2
	
	func _init(texture:Texture2D, region:Rect2):
		self.texture = texture
		self.region = region
		
func _ready():
	_tiles.resize(MAP_HEIGHT * MAP_WIDTH)

func setup(tile_data:PackedInt32Array) -> void:  
	for y in MAP_HEIGHT:
		for x in MAP_WIDTH:
			var index = x + y * MAP_WIDTH
			
			var tile_id = tile_data[index]
			var tile = _get_tile_from_data(tile_id)
			
			_tiles[index] = tile 
			
func set_tile(x:int, y:int, tile_id:int) -> void:
	var index = x + y * MAP_WIDTH 
	var tile = _get_tile_from_data(tile_id)
	
	_tiles[index] = tile 

func _process(_delta:float) -> void:
	queue_redraw()
	
func _draw() -> void: 
	if _tiles.size() == 0:
		return
	
	var viewport_size = get_viewport_rect().size
	
	for y in MAP_HEIGHT:
		for x in MAP_WIDTH: 
			var index = x + y * MAP_WIDTH
			var tile = _tiles[index]
			var tile_position = Rect2(x * TILE_SIZE , y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
			
			if tile and tile.texture: 
				draw_texture_rect_region(tile.texture, tile_position, tile.region)

func _get_tileset_texture(id:int) -> Texture2D:
	if _texture_cache.has(id):
		return _texture_cache[id]
		
	var texture =  ResourceLoader.load(TEXTURE_PATH % id)
	_texture_cache[id] = texture
	
	return texture
	
func _get_tile_from_data(id:int) -> Tile: 
	if id <= 0:
		return Tile.new(null, Rect2())
	
	var grh = Global.grh_data[id]
	
	if grh.num_frames > 1:
		grh = Global.grh_data[grh.frames[1]]
	
	var texture = _get_tileset_texture(grh.file_num)
	var region = grh.region
	
	return Tile.new(texture, region) 
