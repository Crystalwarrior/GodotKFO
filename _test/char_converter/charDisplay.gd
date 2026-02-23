extends Node2D

@onready var aspect_ratio_container: AspectRatioContainer = $".."
@onready var preview_texture_rect: TextureRect = %PreviewTextureRect

@export var preview_height: float = 1.0

var position_offset_normal: Vector2 = Vector2(0.0, 0.0)

func _set_aspect():
	var VP_Rect = get_viewport_rect()
	var aspect = VP_Rect.size.x / VP_Rect.size.y

	aspect_ratio_container.ratio = aspect
	calc_preview_height()

func calc_preview_height():
	var area = aspect_ratio_container.get_rect()
	var base_position
	preview_texture_rect.size.x = area.size.x
	preview_texture_rect.size.y = preview_height * area.size.y
	preview_texture_rect.position = -preview_texture_rect.size / 2
	base_position = Vector2(area.size.x/2, area.size.y - (preview_texture_rect.size.y/2))
	position = base_position + (area.size * position_offset_normal)

func _on_aspect_ratio_container_item_rect_changed() -> void:
	_set_aspect()
