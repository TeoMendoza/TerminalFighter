class_name Bullet
extends Area2D

const projectile_scene: PackedScene = preload("res://Ninja/Scenes/Bullet.tscn")
const sumo_projectile_scene: PackedScene = preload("res://Sumo/Scenes/CoinBag.tscn")

@export var speed: float # Speed of the bullet
@export var damage: int # Damage dealt on hit
@export var lifetime: float  # Time before bullet disappears
@export var anim_sprite: AnimatedSprite2D
@export var col_shape: CollisionShape2D

var owner_id: int
var direction: Vector2 # Angle of player cursor in radians
var travel_info: Vector2
var direction_string: String = ""
# Scene constructor, spawns bullet at the players aim arrow
static func new_bullet(player, player_direction: Vector2, spawn_position: Vector2, character):
	var bullet
	match character:
		"Ninja":
			bullet = projectile_scene.instantiate()
		"Sumo":
			bullet = sumo_projectile_scene.instantiate()
			#bullet = sumo_projectile_scene.instantiate()
			
	var area_2d = bullet.get_node("Area2D")
	area_2d.direction = player_direction
	bullet.global_position = spawn_position
	area_2d.global_position = spawn_position
	area_2d.owner_id = player.player_id
	return bullet

# Starts bullet timer and kills it at the end of timer
func _ready():
	anim_sprite.play("Moving")
	travel_info = Vector2(direction.x * speed, direction.y * speed)
	if travel_info.x >= 0:
		direction_string = "Right"
		anim_sprite.flip_h = true
	else:
		direction_string = "Left"
		anim_sprite.flip_h = false
	await get_tree().create_timer(lifetime).timeout
	play_break_animation()

# Movement
func _process(delta):
	position += travel_info * delta

# Bullet collision cases
func _on_body_entered(body):
	if body.is_in_group("Player") and body.player_id != owner_id:
		if body.is_in_group("Ninja"):
			if body.blocking:
				body.ability2.attack_blocked(self)
			elif body.dashing:
				pass
			else:
				body.take_damage(damage)  # Calls the enemy's damage function
				play_break_animation()
				
		elif body.is_in_group("Sumo"):
			if body.carbed_up:
				body.take_damage(10)
			else:
				body.take_damage(damage)  # Calls the enemy's damage function
			play_break_animation()
			
	if body.is_in_group("Border"):  # Hits a wall
		play_break_animation()

func play_break_animation():
	col_shape.call_deferred("set_disabled", true)
	anim_sprite.play("Break")
	travel_info = Vector2(0,0)
	await get_tree().create_timer(0.3).timeout
	get_parent().queue_free()
