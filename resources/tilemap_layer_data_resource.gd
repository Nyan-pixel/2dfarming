class_name TileMapLayerDataResource
extends NodeDataResource

<<<<<<< Updated upstream
@export var tiles := []

func _save_data(node: Node2D) -> void:
	super._save_data(node)

	var layer := node as TileMapLayer
	tiles.clear()

	for cell in layer.get_used_cells():
		tiles.append({
			"pos": cell,
			"source": layer.get_cell_source_id(cell),
			"atlas": layer.get_cell_atlas_coords(cell),
			"alt": layer.get_cell_alternative_tile(cell)
		})
func _load_data(window: Window) -> void:
	var layer := window.get_node(node_path) as TileMapLayer

	layer.clear()

	for tile in tiles:
		layer.set_cell(
			tile["pos"],
			tile["source"],
			tile["atlas"],
			tile["alt"]
		)
=======
@export var tilemap_layer_used_cells: Array[Vector2i]
@export var terrain_set: int = 0
@export var terrain: int = 3

func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	var tilemap_layer: TileMapLayer = node as TileMapLayer
	var cells: Array[Vector2i] = tilemap_layer.get_used_cells()
	
	tilemap_layer_used_cells = cells

func _load_data(window: Window) -> void:
	var scene_node = window.get_node_or_null(node_path)
	
	if scene_node != null:
		var tilemap_layer: TileMapLayer = scene_node as TileMapLayer
		if tilemap_layer != null:
			tilemap_layer.set_cells_terrain_connect(tilemap_layer_used_cells, terrain_set, terrain, true)
		else:
			print("ERROR: Node at path ", node_path, " is not a TileMapLayer!")
>>>>>>> Stashed changes
