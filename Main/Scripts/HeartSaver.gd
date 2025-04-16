extends Sprite2D

const SAVE_PATH_FULL = "res://Sprites/one_quarter_full.png"
# Called when the node enters the scene tree for the first time.
func _ready():
	var texture: Texture2D = self.texture
	var image: Image = texture.get_image()  # Get the full image

	var region = self.region_rect  # Get the selected region
	var cropped_image = image.get_region(region)  # Crop it to the region

	cropped_image.save_png(SAVE_PATH_FULL)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
