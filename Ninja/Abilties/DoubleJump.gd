class_name DoubleJumpAbility
extends Ability

func init():
	pass

# Script is relatively unnesecary but continues the modular reuasable idea
func execute(player):
	ability_logic(player)

func ability_logic(player):
	player.jumps -= 1
