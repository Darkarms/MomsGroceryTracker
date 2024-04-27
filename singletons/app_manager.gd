extends Node

const PRODUCT_PRICE = 0
const PRODUCT_WEIGHT = 1
const PRODUCT_WEIGHT_METRIC = 2

var main_scene: PackedScene = preload("res://scenes/main.tscn")
var add_scene: PackedScene = preload("res://scenes/add_item.tscn")
var remove_scene: PackedScene = preload("res://scenes/remove_entry.tscn")

var productsList = {}

func LoadMainScene() -> void:
	get_tree().change_scene_to_packed(main_scene)

func LoadAddScene() -> void:
	get_tree().change_scene_to_packed(add_scene)

func LoadRemoveScene() -> void:
	get_tree().change_scene_to_packed(remove_scene)
	
func GetProductsList() -> Dictionary:
	return productsList

func SaveData() -> void:
	var saveData = FileAccess.open("user://appdata.save", FileAccess.WRITE)
	var json_string = JSON.stringify(productsList)
	saveData.store_line(json_string)

func LoadData() -> void:
	if not FileAccess.file_exists("user://appdata.save"):
		return
	var saveData = FileAccess.open("user://appdata.save", FileAccess.READ)
	while saveData.get_position() < saveData.get_length():
		var json_string = saveData.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON PARSE ERROR!: ", json.get_error_message(), " in ", json_string,  " at line ", json.get_error_line())
			return
		var node_data = json.get_data()
		for key in node_data.keys():
			set_dict(key, node_data[key])
			
func set_dict(key: String, value) -> void:
	productsList[key] = value
	
func round_to_dec(num, digit) -> float:
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
