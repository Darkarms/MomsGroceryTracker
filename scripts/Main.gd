extends Node2D

@onready var product_name: LineEdit = $ProductName
@onready var vbox: VBoxContainer = $ProductName/ScrollContainer/Vbox
@onready var scroll_container: ScrollContainer = $ProductName/ScrollContainer
@onready var productsList = AppManager.GetProductsList()
@onready var weight_options: OptionButton = $ProductDataScroll/ProductDataVbox/weightOptions
@onready var avg_price_data: Label = $ProductDataScroll/ProductDataVbox/AvgPrice/AvgPriceData
@onready var low_price_data: Label = $ProductDataScroll/ProductDataVbox/LowPrice/LowPriceData
@onready var high_price_data: Label = $ProductDataScroll/ProductDataVbox/HighPrice/HighPriceData

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

func RetrieveAndProccessData() -> void:
	var weightTypeID = weight_options.get_selected_id()
	var weightType = weight_options.get_item_text(weightTypeID)
	var avgMinMax = ConvertToWeightType(weightType)
	if avgMinMax and avgMinMax[0] == null:
		avg_price_data.text = "N/A"
		low_price_data.text = "N/A"
		high_price_data.text = "N/A"
	elif avgMinMax:
		avg_price_data.text = str(avgMinMax[0])
		low_price_data.text = str(avgMinMax[1])
		high_price_data.text = str(avgMinMax[2])

func ConvertToWeightType(weightType) -> Array:
	if product_name.text not in productsList:
		return []
	var pricesData = productsList[product_name.text]["price_weight"]
	var avgMinMax = []
	var priceHigh = null
	var priceLow = null	
	var priceAvg = null
	for i in range(pricesData.size()):
		var convertFrom = pricesData[i][AppManager.PRODUCT_WEIGHT_METRIC]
		var priceStart = pricesData[i][AppManager.PRODUCT_PRICE]
		var weightStart = pricesData[i][AppManager.PRODUCT_WEIGHT]
		var priceEnd = null
		var weightEnd = weightStart
		match weightType:
			"LB":
				if convertFrom == "L" or convertFrom == "ML":
					pass
				elif convertFrom == "KG":
					weightEnd *= 2.20462
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
				elif convertFrom == "G":
					weightEnd /= 453.6
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
				elif convertFrom == "LB":
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
			"KG":
				if convertFrom == "L" or convertFrom == "ML":
					pass
				elif convertFrom == "LB":
					weightEnd /= 2.20462
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
				elif convertFrom == "G":
					weightEnd /= 1000.0
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
				elif convertFrom == "KG":
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
			"G":
				if convertFrom == "L" or convertFrom == "ML":
					pass
				elif convertFrom == "LB":
					weightEnd *= 453.6
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
				elif convertFrom == "KG":
					weightEnd *= 1000.0
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd	
					else:
						priceEnd = priceStart * weightEnd
				elif convertFrom == "G":
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd	
					else:
						priceEnd = priceStart * weightEnd
			"ML":
				if convertFrom == "G" or convertFrom == "KG":
					pass
				elif convertFrom == "L":
					weightEnd *= 1000.0
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
				elif convertFrom == "ML":
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
			"L":
				if convertFrom == "G" or convertFrom == "KG":
					pass
				elif convertFrom == "ML":
					weightEnd /= 1000.0
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
				elif convertFrom == "L":
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
			"Unit":
				if convertFrom == "G" or convertFrom == "KG" or convertFrom == "L" or convertFrom == "LB" or convertFrom == "ML":
					continue
				elif convertFrom == "Unit":
					if weightEnd >= 1.0:
						priceEnd = priceStart / weightEnd
					else:
						priceEnd = priceStart * weightEnd
		if not priceEnd:
			continue
		priceEnd = AppManager.round_to_dec(priceEnd, 2)
		if not priceLow:
			priceLow = priceEnd
		elif priceLow > priceEnd:
			priceLow = priceEnd
		if not priceHigh:
			priceHigh = priceEnd
		elif priceHigh < priceEnd:
			priceHigh = priceEnd	
		if not priceAvg:
			priceAvg = priceEnd
		else:
			priceAvg = (priceAvg + priceEnd) / 2
			priceAvg = AppManager.round_to_dec(priceAvg, 2)
	avgMinMax.append(priceAvg)
	avgMinMax.append(priceLow)
	avgMinMax.append(priceHigh)
	return avgMinMax
	
func AddButton(text) -> void:
	var button = Button.new()
	button.text = text
	button.pressed.connect(products_option_pressed.bind(text))
	button.add_theme_font_override("font", buttonFont)
	button.add_theme_font_size_override("font_size", 35)
	vbox.add_child(button)
	
func _on_product_name_text_changed(new_text: String) -> void:
	buttons = vbox.get_children()
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


func _on_product_name_text_submitted(_new_text: String) -> void:
	if scroll_container.visible == true:
		scroll_container.hide()

func products_option_pressed(productName) -> void:
	product_name.text = productName
	RetrieveAndProccessData()
	scroll_container.hide()


func _on_weight_options_item_selected(_index: int) -> void:
	RetrieveAndProccessData()
