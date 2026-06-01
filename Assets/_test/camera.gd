extends Camera2D

@export var point_collection: Node2D

var zoomtween: Tween
var current_point: Node2D

func _unhandled_input(event):
	if not point_collection:
		return
	if event.is_action_pressed("ui_left"):
		var idx = (current_point.get_index() - 1) % point_collection.get_children().size()
		var point = point_collection.get_child(idx)
		set_campoint(point)
	if event.is_action_pressed("ui_right"):
		var idx = abs((current_point.get_index() + 1) % point_collection.get_children().size())
		var point = point_collection.get_child(idx)
		set_campoint(point)


func _ready():
	if point_collection:
		set_campoint(point_collection.get_child(0))


func set_campoint(point, duration: float = 0.75):
	if not point_collection:
		return

	if point is int:
		point = point_collection.get_child(point)
	current_point = point
	var scale_to = Vector2(1,1) / current_point.scale
	zoom_to(current_point.global_position, scale_to, duration)


func zoom_to(target_pos: Vector2, target_zoom: Vector2 = Vector2(1, 1), duration: float = 1.0):
	if zoomtween:
#		zoomtween.custom_step(9999)
		zoomtween.kill()
	if duration <= 0:
		global_position = target_pos
		zoom = target_zoom
		return
	zoomtween = create_tween()
	zoomtween.tween_property(self, "global_position", target_pos, duration).set_trans(Tween.TRANS_QUINT)
	zoomtween.parallel().tween_property(self, "zoom", target_zoom, duration).set_trans(Tween.TRANS_QUINT)
