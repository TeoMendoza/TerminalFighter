class_name NinjaUI
extends Control

var ui_visible: bool = true
var player = CharacterBody2D

@export var Heart1: TextureRect
@export var Heart2: TextureRect
@export var Heart3: TextureRect

@onready var hearts = [$HealthIcons/Heart1, $HealthIcons/Heart2, $HealthIcons/Heart3]
const FullHeart = preload("res://Main/Assets/Misc/full.png")
const Heart3_4 = preload("res://Main/Assets/Misc/three_quarters_full.png")
const HalfHeart = preload("res://Main/Assets/Misc/half_full.png")
const Heart1_4 = preload("res://Main/Assets/Misc/one_quarter_full.png")

func set_player(player):
	self.player = player
	
func _process(delta):
	if ui_visible:
		global_position = player.global_position - Vector2(0, 10)
	
func toggle_ui():
	ui_visible = !ui_visible
	visible = ui_visible
	

func update_hearts(new_health):
	update_hearts_rpc.rpc(new_health)
	var full_hearts = new_health / 40 # Godot auto floor divides if both are integers
	var remainder_health = new_health % 40
	for i in range(3):
		if i < full_hearts:
			hearts[i].texture = FullHeart
		elif i == full_hearts:
			if remainder_health == 30:
				hearts[i].texture = Heart3_4
			elif remainder_health == 20:
				hearts[i].texture = HalfHeart
			elif remainder_health == 10:
				hearts[i].texture = Heart1_4
			else:
				hearts[i].texture = null
		else:
			hearts[i].texture = null
			
@rpc ("any_peer")
func update_hearts_rpc(new_health):
	var full_hearts = new_health / 40 # Godot auto floor divides if both are integers
	var remainder_health = new_health % 40
	for i in range(3):
		if i < full_hearts:
			hearts[i].texture = FullHeart
		elif i == full_hearts:
			if remainder_health == 30:
				hearts[i].texture = Heart3_4
			elif remainder_health == 20:
				hearts[i].texture = HalfHeart
			elif remainder_health == 10:
				hearts[i].texture = Heart1_4
			else:
				hearts[i].texture = null
		else:
			hearts[i].texture = null
