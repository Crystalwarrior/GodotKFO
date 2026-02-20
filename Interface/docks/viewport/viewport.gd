@tool
extends ColorRect

@onready var aspect_ratio_container: AspectRatioContainer = %AspectRatioContainer
@onready var viewport_texture_rect: TextureRect = %ViewportTextureRect

@export var viewport_texture: ViewportTexture:
	set(value):
		viewport_texture = value
		viewport_texture_rect.set_texture(viewport_texture)

func _ready():
	if viewport_texture != null:
		set_viewport_texture(viewport_texture)

func set_viewport_texture(p_viewport_texture: ViewportTexture) -> void:
	viewport_texture_rect.set_texture(p_viewport_texture)

func get_screenshot() -> Texture:
	# Get a snapshot of it
	return ImageTexture.create_from_image(viewport_texture_rect.get_texture().get_image())
