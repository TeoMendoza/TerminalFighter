class_name Player
extends CharacterBody2D

var ability_ui # No type, not sure if I will reuse the UI since there is no more ability icons

# Syncrhonized variables + assigned variables through the inspector
@export var health: int
@export var speed: float
@export var jump_force: float
@export var gravity: float
@export var passive_ability: Ability
@export var ability1: Ability
@export var ability2: Ability
@export var attack: Attack
@export var ability_ui_scene: PackedScene
@export var is_using_ability = false
@export var player_id := 1:
	set(id):
		player_id = id
		self.set_multiplayer_authority(id)

func _ready():
	pass

func _physics_process(delta):
	push_error("physcics_process() must be implemented in a child class!")

# Abstract-like method placeholders to be implemented by child classes
func jump():
	push_error("jump() must be implemented in a child class!")

func attack_action():
	push_error("attack_action() must be implemented in a child class!")

func use_ability_1(delta):
	push_error("use_ability_1() must be implemented in a child class!")

func use_ability_2(delta):
	push_error("use_ability_2() must be implemented in class!")
	
func update_animation():
	push_error("update_animation() must be implemented in a child class!")
	
func get_facing_direction():
	var mouse_pos = get_global_mouse_position()  # Get mouse position in world coordinates
	var direction = (mouse_pos - global_position).normalized()  # Get direction to mouse
	return Vector2(cos(direction.angle()), sin(direction.angle()))  # Get angle in radians
	
# Base take_damage, some characters will override it however
func take_damage(damage):
	health -= damage

func update_aim_indicator():
	push_error("update_aim_indicator must be implemented in a child class!")

func _input(event):
	if (event.is_action_pressed("toggle") and get_multiplayer_authority() == multiplayer.get_unique_id()):
		ability_ui.toggle_ui()  # Toggle the UI visibility
