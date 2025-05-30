extends Control

signal ready_pressed(selected_character: String) # Signal to notify `Main.gd` when a player is ready

@onready var ready_button = $ReadyButton
@onready var character_icon = $CharacterIcon
@onready var character_selector = $CharacterSelector
@onready var selected_character: String = "Ninja"

var playable_characters: Array[String] = ["Ninja", "Sumo"]


func _ready():
	ready_button.pressed.connect(_on_ready_pressed)
	for character in playable_characters:
		character_selector.add_item(character)
	
func _on_ready_pressed():
	ready_pressed.emit(selected_character)  # Tell `Main.gd` to handle connecting
	ready_button.disabled = true  # Prevent multiple clicks
	ready_button.text = "Looking For Match"

func _process(delta):
	if selected_character == "Ninja":
		character_icon.play("Ninja")
	elif selected_character == "Sumo":
		character_icon.play("Sumo")

func _on_character_selector_item_selected(index):
	selected_character = character_selector.get_item_text(index)

func ninja_animations():
	pass
