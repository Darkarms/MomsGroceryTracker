extends Node2D

@onready var weight_box: SpinBox = $weight/weightBox
@onready var price_box: SpinBox = $priceLabel/priceBox
@onready var product_name: LineEdit = $nameLabel/ProductName
@onready var weight_options: OptionButton = $weight/weightOptions
@onready var scroll_container: ScrollContainer = $nameLabel/ScrollContainer
@onready var vbox: VBoxContainer = $nameLabel/ScrollContainer/Vbox

@onready var productsList = AppManager.GetProductsList()

var buttonFont = load("res://assets/Fonts/LuckiestGuy-Regular.ttf")
var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weight_box.rounded = false
	price_box.rounded = false
	if not AppManager.GetProductsList():
		AppManager.LoadData()
	for p in productsList.keys():
		AddButton(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func AddButton(text) -> void:
	var button = Button.new()
	button.text = text
	button.pressed.connect(products_option_pressed.bind(text))
	button.add_theme_font_override("font", buttonFont)
	button.add_theme_font_size_override("font_size", 45)
	vbox.add_child(button)
	
func _on_back_to_main_button_pressed() -> void:
	AppManager.LoadMainScene()


func _on_add_item_button_pressed() -> void:
	var allValuesSet = false
	
	var productName = product_name.get_text()
	var productPrice = price_box.value
	var productWeight = weight_box.value
	
	var weightTypeID = weight_options.get_selected_id()
	var weightType = weight_options.get_item_text(weightTypeID)
	
	if productWeight != 0.01 and productPrice != 0.01 and productName != "" and weightTypeID != -1:
		allValuesSet = true
	if allValuesSet:
		if not productsList.has(productName):
			productsList[productName] = {}
			productsList[productName]["price_weight"] = []
			AddButton(productName)
		productsList[productName]["price_weight"].append([productPrice, productWeight, weightType])
		
		AppManager.SaveData()
		#reset values for next addition
		productName = ""
		productWeight = 0.01
		productPrice = 0.01
			
		
		


func _on_product_name_text_changed(new_text: String) -> void:
	buttons = vbox.get_children()
	if product_name.has_focus():
		scroll_container.show()
		for b in buttons:
			if new_text in b.text:
				b.show()
			else:
				b.hide()
	


func _on_product_name_text_submitted(_new_text: String) -> void:
	if scroll_container.visible == true:
		scroll_container.hide()
		
func products_option_pressed(productName) -> void:
	product_name.text = productName
	scroll_container.hide()
