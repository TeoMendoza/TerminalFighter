class_name BlockAbility
extends Ability

const block_duration: float = 0.25
var block_timer

func init():
	pass

# Gets called once when dash is usable, does not get called again until they start the ability again
func execute(player):
	# Logic Boolean Adjustment
	owner.blocking = true
	owner.anim_sprite.play("Block")
	owner.current_animation = "Block"
	owner.animation_locked = true
	owner.is_using_ability = true
	owner.speed = 50
	block_timer = block_duration

func attack_blocked(bullet):
	if owner.last_facing_direction == "Left" and bullet.direction_string == "Right":
		bullet.travel_info.x = bullet.travel_info.x * -1
		bullet.travel_info.y = bullet.travel_info.y * -1
		bullet.direction_string = "Left"
		bullet.owner_id = owner.player_id
	elif owner.last_facing_direction == "Right" and bullet.direction_string == "Left":
		bullet.travel_info.x = bullet.travel_info.x * -1
		bullet.travel_info.y = bullet.travel_info.y * -1
		bullet.direction_string = "Right"
		bullet.owner_id = owner.player_id
	else:
		# These two lines go here because the death animation needs to play, and if they are in end block, they happen after the animation and override it with the stop
		owner.anim_sprite.stop()
		owner.animation_locked = false
		
		owner.take_damage(bullet.damage)
		bullet.queue_free()
		
	end_block(owner)
	
func process_block(delta):
	block_timer -= delta
	if block_timer <= 0:
		end_block(owner)
	
func end_block(player):
	owner.blocking = false
	owner.is_using_ability = false
	owner.speed = 250
	owner.block_on_cooldown = true
	await owner.get_tree().create_timer(cooldown).timeout
	owner.ability_anim_sprite.play("Block")
	owner.block_on_cooldown = false

# Same function as end_block, different name to clarify scenario, also not all abilities will have the same end_if_slammed function
func end_block_if_slammed():
	owner.blocking = false
	owner.is_using_ability = false
	owner.speed = 250
	owner.block_on_cooldown = true
	await owner.get_tree().create_timer(cooldown).timeout
	owner.ability_anim_sprite.play("Block")
	owner.block_on_cooldown = false
