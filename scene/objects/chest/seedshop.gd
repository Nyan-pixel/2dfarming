extends Node2D

var balloon_scene = preload("res://Dialog/game_dialogue_balloon.tscn")

@export var dialogue_start_command: String = "start"

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool
var is_shop_open: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	if is_shop_open:
		if animated_sprite_2d.sprite_frames.has_animation("chest_close"):
			animated_sprite_2d.play("chest_close")
	
	is_shop_open = false
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range and not is_shop_open:
		if event.is_action_pressed("show_dialogue"):
			interactable_label_component.hide()
			
			if animated_sprite_2d.sprite_frames.has_animation("chest_open"):
				animated_sprite_2d.play("chest_open")
				
			is_shop_open = true
			
			# Set this specific instance as the active shop
			InventoryManager.current_shop = self
			
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(load("res://Dialog/Conversation/chest.dialogue"), dialogue_start_command)

### ─── SEED SHOP TRANSACTION SYSTEM ─── ###

func buy_seeds(seed_type: String, tool_enum_value: DataTypes.Tools, single_cost: int, amount: int) -> bool:
	var total_cost = single_cost * amount
	
	# Spend gold using your PlayerProgress Autoload
	if not PlayerProgressManager.spend_gold(total_cost):
		print("Not enough gold!")
		return false
	
	# Add items to inventory dictionary
	if InventoryManager.inventory.has(seed_type):
		InventoryManager.inventory[seed_type] += amount
	else:
		InventoryManager.inventory[seed_type] = amount
		
	# Unlock the hotbar slot buttons
	ToolManager.enable_tool.emit(tool_enum_value)
	
	# Refresh UI panel tracking labels
	InventoryManager.inventory_changed.emit()
	return true
