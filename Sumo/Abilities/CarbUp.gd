class_name CarbUp
extends Ability

const carb_up_duration: int = 2

func execute(player):
	owner.carbed_up = true
	owner.carb_up_on_cooldown = true
	owner.speed *= 1.25
	owner.ability_anim_sprite.play("Fart")
	await owner.get_tree().create_timer(carb_up_duration).timeout
	owner.carbed_up = false
	owner.speed *= 0.8
	await owner.get_tree().create_timer(cooldown - carb_up_duration).timeout
	owner.carb_up_on_cooldown = false
	#owner.ability_anim_sprite.play("CarbUp")
	

func ability_logic(player):
	push_error("ability_logic() must be implemented in a child class!")

