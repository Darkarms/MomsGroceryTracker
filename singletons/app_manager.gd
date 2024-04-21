extends Node

var main_scene: PackedScene = preload("res://scenes/main.tscn")
var add_scene: PackedScene = preload("res://scenes/add_item.tscn")

var productsList = {}

func LoadMainScene() -> void:
	get_tree().change_scene_to_packed(main_scene)

func LoadAddScene() -> void:
	get_tree().change_scene_to_packed(add_scene)

func GetProductList() -> dictionary:
	return productsList
