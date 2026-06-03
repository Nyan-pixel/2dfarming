extends Sprite2D

# 1. ADD THIS EXPORT VARIABLE AT THE TOP
# This allows you to change the log amount for each tree size in the Inspector!
@export var log_drop_amount: int = 1

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scene/objects/trees/log.tscn")

func _ready() -> void:
 hurt_component.hurt.connect(on_hurt)
 damage_component.max_damaged_reached.connect(on_max_damaged_reached)

func on_hurt(hit_damage: int) -> void:
 damage_component.apply_damage(hit_damage)
 material.set_shader_parameter("shake_intensity", 0.5)
 await get_tree().create_timer(1.0).timeout
 material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damaged_reached() -> void:
 call_deferred("add_log_scene")
 print("max damaged reached")
 queue_free()

func add_log_scene() -> void:
 if not log_scene:
  return
  
 # 2. LOOP LOG SPAWNING BASED ON THE EXPORT VARIABLE
 for i in range(log_drop_amount):
  var log_instance = log_scene.instantiate() as Node2D
  
  # Give logs a tiny random offset so they don't stack perfectly on top of each other
  var random_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
  log_instance.global_position = global_position + random_offset
  
  get_parent().add_child(log_instance)
