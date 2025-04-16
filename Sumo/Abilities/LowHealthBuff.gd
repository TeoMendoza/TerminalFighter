class_name LowHealthBuff
extends Ability

var used: bool = false
func execute(player):
	if not used:
		owner.speed *= 1.5
		used = true

func ability_logic(player):
	push_error("ability_logic() must be implemented in a child class!")

