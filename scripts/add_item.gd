extends Node2D

@onready var weight_box: SpinBox = $weight/weightBox
@onready var price_box: SpinBox = $priceLabel/priceBox
@onready var product_name: LineEdit = $nameLabel/ProductName

@onready var productsList = AppManager.GetProductsList()

var productName = ""
var productPrice = 0.01
var productWeight = 0.01
var allValuesSet = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weight_box.rounded = false
	price_box.rounded = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_to_main_button_pressed() -> void:
	AppManager.LoadMainScene()


func _on_add_item_button_pressed() -> void:
	productName = product_name.get_selected_text()
	productPrice = price_box.get_line_edit()
	productWeight = weight_box.get_line_edit()
	if productWeight != 0.01 and productPrice != 0.01 and productName != "":
		allValuesSet = true
	if allValuesSet:
		if product_name not in productsList:
			productsList[product_name] = {}
		
		
		
