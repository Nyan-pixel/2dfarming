extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering: Button = $MarginContainer/HBoxContainer/ToolWatering
@onready var corn: Button = $MarginContainer/HBoxContainer/Corn
@onready var tomato: Button = $MarginContainer/HBoxContainer/Tomato

# List of all UI slot buttons to reset their brightness
var all_buttons: Array = []

func _ready() -> void:
	# 1. Connect all buttons to their click functions programmatically
	tool_axe.pressed.connect(_on_axe_pressed)
	tool_tilling.pressed.connect(_on_tilling_pressed)
	tool_watering.pressed.connect(_on_watering_pressed)
	corn.pressed.connect(_on_corn_pressed)
	tomato.pressed.connect(_on_tomato_pressed)
	
	# 2. Put all buttons into an array so we can dim them down cleanly
	all_buttons = [tool_axe, tool_tilling, tool_watering, corn, tomato]
	
	# 3. Listen to the global ToolManager signal for hotkey presses (O/P)
	ToolManager.tool_selected.connect(_on_global_tool_selected)
	
	# Run once on startup to set up the default visual state
	_on_global_tool_selected(ToolManager.selected_tool)


# ─── THE VISUAL HIGHLIGHT FIX ───
func _on_global_tool_selected(active_tool: DataTypes.Tools) -> void:
	# Step A: Dim ALL buttons in the slot row by default (including seeds!)
	for btn in all_buttons:
		if btn:
			btn.modulate = Color(0.6, 0.6, 0.6, 1.0) # Clean, uniform grayish tint
	
	# Step B: Brighten ONLY the button matching our active tool selection
	match active_tool:
		DataTypes.Tools.AxeWood:
			tool_axe.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.TillGround:
			tool_tilling.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.WaterCrops:
			tool_watering.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.PlantCorn:
			corn.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.PlantTomato:
			tomato.modulate = Color(1.5, 1.5, 1.5, 1.0)
		# 💡 (Optional) If you add seed states to your tool enum later, add them here!
		# DataTypes.Tools.PlantCorn:
		#     corn.modulate = Color(1.5, 1.5, 1.5, 1.0)


# ─── MOUSE CLICK SELECTION ───
func _on_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)

func _on_tilling_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.TillGround)

func _on_watering_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WaterCrops)

func _on_corn_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantCorn)
	# If you want corn clicks to do something, assign its tool type here later!

func _on_tomato_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantTomato)
	# If you want tomato clicks to do something, assign its tool type here later!
