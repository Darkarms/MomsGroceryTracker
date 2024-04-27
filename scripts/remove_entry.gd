extends Node2D

@onready var scroll_container: ScrollContainer = $nameLabel/ScrollContainer
@onready var vbox: VBoxContainer = $nameLabel/ScrollContainer/VboxProduct
@onready var product_name: LineEdit = $nameLabel/ProductName
@onready var productsList = AppManager.GetProductsList()
@onready var v_box_entries: VBoxContainer = $ListOfEntries/VBoxEntries

var buttonFont = load("res://assets/Fonts/LuckiestGuy-Regular.ttf")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
	
func UpdateProducts() -> void:
	ClearProductEntries()
	DisplayProducts()
	
func ClearProductEntries() -> void:
	for c in v_box_entries.get_children():
		v_box_entries.remove_child(c)
		c.queue_free()
		
func DisplayProducts() -> void:
	var productName = product_name.text
	if productName in productsList:
		var product_prices = productsList[productName]["price_weight"]
		for i in range(product_prices.size()):
			var button = CheckBox.new()
			var buttonText = "$" + str(product_prices[i][AppManager.PRODUCT_PRICE]) + " - " + str(product_prices[i][AppManager.PRODUCT_WEIGHT]) + str(product_prices[i][AppManager.PRODUCT_WEIGHT_METRIC])
			button.text = buttonText
			button.pressed.connect(product_entry_pressed.bind(buttonText))
			button.add_theme_font_override("font", buttonFont)
			button.add_theme_font_size_override("font_size", 45)
			v_box_entries.add_child(button)

func product_entry_pressed(buttonText) -> void: 
	pass
	
func products_option_pressed(name) -> void:
	product_name.text = name
	UpdateProducts()
	scroll_container.hide()
	
func _on_remove_button_pressed() -> void:
	var checkBoxs = v_box_entries.get_children()
	var productEntries = productsList[product_name.text]["price_weight"]
	for i in range(checkBoxs.size()):
		if productEntries and checkBoxs[i].button_pressed == true:
			productEntries.remove_at(i)
	UpdateProducts()
	AppManager.SaveData()

func _on_back_to_main_button_pressed() -> void:
	AppManager.LoadMainScene()


func _on_product_name_text_submitted(new_text: String) -> void:
	if scroll_container.visible == true:
		scroll_container.hide()
	UpdateProducts()


func _on_product_name_text_changed(new_text: String) -> void:
	var buttons = vbox.get_children()
	if product_name.has_focus():
		scroll_container.show()
		for b in buttons:
			if new_text in b.text:
				b.show()
			else:
				b.hide()
