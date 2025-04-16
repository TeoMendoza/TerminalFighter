class_name Attack
extends Resource

@export var cooldown: float
@export var projectile_scene: PackedScene
var owner: Player = null

func execute(player):
	push_error("execute() must be implemented in child class")
