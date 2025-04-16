class_name Ability
extends Resource

@export var cooldown: float
@export var animation_name: String
var owner: Player

func execute(player):
	push_error("ability_logic() must be implemented in a child class!")

func ability_logic(player):
	push_error("ability_logic() must be implemented in a child class!")
