extends Node2D

@onready var texture_button: TextureButton = $TextureButton
@onready var product_name: LineEdit = $ProductName
@onready var vbox: VBoxContainer = $ProductName/ScrollContainer/Vbox
@onready var scroll_container: ScrollContainer = $ProductName/ScrollContainer
@onready var productsList = AppManager.GetProductsList()

var buttonFont = load("res://assets/Fonts/LuckiestGuy-Regular.ttf")
var buttons = []

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
	
func _on_product_name_text_changed(new_text: String) -> void:
	var buttons = vbox.get_children()
	if product_name.has_focus():
		scroll_container.show()
		for b in buttons:
			if new_text in b.text:
				b.show()
			else:
				b.hide()
				
func _on_add_item_button_pressed() -> void:
	AppManager.LoadAddScene() 


func _on_tree_entered() -> void:
	pass


func _on_remove_entry_button_pressed() -> void:
	AppManager.LoadRemoveScene()


func _on_product_name_text_submitted(new_text: String) -> void:
	if scroll_container.visible == true:
		scroll_container.hide()

func products_option_pressed(name) -> void:
	product_name.text = name
	scroll_container.hide()
