class_name DashAbility
extends Ability

const dash_distance: int = 600
const dash_duration: float = 0.25
var dash_timer

func init():
	pass

# Gets called once when dash is usable, does not get called again until they start the ability again
func execute(player):
	# Logic Boolean Adjustment
	owner.dashing = true
	dash_timer = dash_duration
	owner.anim_sprite.play("Dash")
	owner.current_animation = "Dash"
	owner.animation_locked = true
	owner.is_using_ability = true
	# Apply velocity for the dash 
	owner.velocity.x = owner.get_dash_direction() * dash_distance  

# Gets called every delta, ends the dash if there is a collision
func process_dash(player, delta):
	owner.velocity.y = 0
	var collision = owner.move_and_collide(owner.velocity * delta)  # Gets collision
	
	# If a collision is recorded, and it's not the floor, then it ends the dash
	if collision:
		var collider = collision.get_collider()
		if not collider.is_in_group("Floor"):
			end_dash(owner)
		
	dash_timer -= delta
	if dash_timer <= 0:
		end_dash(owner)

# Gets called from process_dash()
func end_dash(player):
	# Logic Boolean Adjustment
	owner.dashing = false
	owner.velocity = Vector2.ZERO
	owner.is_using_ability = false
	
	# Player ability boolean adjustment
	owner.dash_on_cooldown = true
	owner.animation_locked = false
	owner.anim_sprite.stop()
	await owner.get_tree().create_timer(cooldown).timeout
	owner.ability_anim_sprite.play("Dash1")
	owner.dash_on_cooldown = false
