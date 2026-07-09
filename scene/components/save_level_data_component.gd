class_name SaveLevelDataComponent
extends Node

var level_scene_name: String
var save_game_data_path: String = "user://game_data/"
var save_file_name: String = "save_%s_game_data.tres"
var game_data_resource: SaveGameDataResource

func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name

func save_node_data() -> void:
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	
	game_data_resource = SaveGameDataResource.new()
	
	if nodes != null:
		for node: SaveDataComponent in nodes:
			if node is SaveDataComponent:
				var save_data_resource: NodeDataResource = node._save_data()
				var save_final_resource = save_data_resource.duplicate()
				game_data_resource.save_data_nodes.append(save_final_resource)

func save_game() -> void:
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)
		
	var level_save_file_name: String = save_file_name % level_scene_name
	
	save_node_data()
	
	game_data_resource.level_scene_path = get_tree().current_scene.scene_file_path
	ResourceSaver.save(game_data_resource, save_game_data_path)
	
	var result: int = ResourceSaver.save(game_data_resource, save_game_data_path + level_save_file_name)
	print("Save result:", result)


func load_game():
	var level_save_file_name := save_file_name % level_scene_name
	var save_path := save_game_data_path + level_save_file_name

	var data: SaveGameDataResource = ResourceLoader.load(save_path)

	if data == null:
		push_error("Save file not found: " + save_path)
		return

	
	
