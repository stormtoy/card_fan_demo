extends Control

# 悬停时提升的像素高度
const HOVER_LIFT := 100
# 悬停时放大倍数
const HOVER_SCALE := 1.5

# 记录初始位置和角度
var original_position := Vector2()
var original_rotation := 0.0


# 由 hand.gd 调用，设置当前的"原始"位置和角度
func set_base_transform(pos: Vector2, rot: float) -> void:
	original_position = pos
	original_rotation = rot

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered():
	Events.card_hover_changed.emit(self, true)
	var tween = create_tween()
	tween.tween_property(self, "position", original_position + Vector2(0, -HOVER_LIFT), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "rotation", 0.0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", Vector2(HOVER_SCALE, HOVER_SCALE), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	Events.card_hover_changed.emit(self, false)
	var tween = create_tween()
	tween.tween_property(self, "position", original_position, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "rotation", original_rotation, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
