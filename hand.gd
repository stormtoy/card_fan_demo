extends Control

# 预加载卡牌UI场景
const CARD_UI_SCENE := preload("res://card_ui.tscn")
const ROT_MAX := 0.2                 # 最大旋转角度
const MAX_CARD_SPACING := -60        # 卡牌之间的最大间距
const SCATTER_OFFSET := 120           # 悬停时其他卡牌散开的额外距离
const ARC_HEIGHT := 40.0            # 弧形最大高度

var base_position := Vector2()       # 手牌基准位置（一般为屏幕下方中央）
var hovered_card_index := -1         # 当前悬停的卡牌索引，-1表示无

func _ready():
	# 获取视口大小
	var viewport_size = get_viewport_rect().size
	# 设置手牌基准位置为屏幕中央偏下
	base_position = Vector2(viewport_size.x / 2, viewport_size.y - 180)
	
	# 定义5种颜色：红黄蓝绿紫
	var colors = [
		Color(1, 0, 0),      # 红色
		Color(1, 1, 0),      # 黄色
		Color(0, 0, 1),      # 蓝色
		Color(0, 1, 0),      # 绿色
		Color(0.5, 0, 0.5),   # 紫色
		Color(1, 0, 0),      # 红色
		Color(1, 1, 0),      # 黄色
		Color(0, 0, 1),      # 蓝色
		Color(0, 1, 0),      # 绿色
		Color(0.5, 0, 0.5),   # 紫色
	]
	
	# 添加5张不同颜色的卡牌
	for i in range(10):
		add_card(colors[i])
		
	
	Events.card_hover_changed.connect(_on_card_hover_changed)

# 添加一张卡牌到手牌，可指定颜色
func add_card(color = null):
	var card = CARD_UI_SCENE.instantiate()  # 实例化卡牌场景
	
	card.set_color(color)
		
	add_child(card)                         # 加入为Hand的子节点
	_update_card_positions()                # 更新所有卡牌的位置和旋转

# 卡牌悬停状态改变时调用
func _on_card_hover_changed(card_ui, is_hovered):
	var cards = get_children()
	hovered_card_index = cards.find(card_ui) if is_hovered else -1
	_update_card_positions()

# 更新所有卡牌的位置和旋转，实现扇形排布
func _update_card_positions():
	var cards = get_children()              # 获取所有子节点（即所有卡牌）
	var card_count = cards.size()           # 当前卡牌数量
	if card_count == 0:
		return                              # 没有卡牌则直接返回

	# 动态获取卡牌宽度（从第一个卡牌获取）
	var card_width = 0
	if cards.size() > 0:
		card_width = cards[0].custom_minimum_size.x
	
	# 计算卡牌间距，不能超过最大间距
	var spacing = min(MAX_CARD_SPACING, size.x / max(card_count, 1))
	# 计算所有卡牌排布所需的总宽度（包括卡牌本身的宽度）
	var total_width = spacing * (card_count - 1) + card_width * card_count
	# 计算最左侧卡牌的x坐标，使整体居中于base_position
	var start_x = base_position.x - total_width / 2

	for i in range(card_count):
		var t = 0.0
		# 归一化t：当有多张卡牌时，t从-1（最左）到1（最右）均匀分布
		if card_count > 1:
			t = (float(i) / float(card_count - 1)) * 2.0 - 1.0
		
		# 计算每张卡牌的旋转角度，最左最大负角度，最右最大正角度
		var rot = t * ROT_MAX
		
		# 计算弧形高度：使用抛物线公式 y = -a * x² + b
		# 这样中间卡牌最高，两边卡牌逐渐降低
		var arc_offset = -ARC_HEIGHT * (t * t) + ARC_HEIGHT
		
		# 计算每张卡牌的目标位置（考虑卡牌宽度）
		var pos = Vector2(start_x + i * spacing + card_width * i, base_position.y - arc_offset)

		# 如果有悬停卡牌，其他卡牌向两边散开
		if hovered_card_index != -1 and i != hovered_card_index:
			var direction = sign(i - hovered_card_index)  # -1:左侧卡牌, 1:右侧卡牌
			pos.x += direction * SCATTER_OFFSET  # 向左/向右移动
			# 悬停时也可以调整弧形效果
			pos.y += arc_offset * 0.5  # 其他卡牌稍微降低

		var card = cards[i]
		# 如果不是当前正在悬停的卡牌（悬停卡牌自己管理动画）
		if i != hovered_card_index or hovered_card_index == -1:
			# 动画移动到目标位置和角度
			var tween = create_tween()
			tween.tween_property(card, "position", pos - position, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(card, "rotation", rot, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

		# 让卡牌记住当前的"原始"位置和角度（即使悬停卡牌，也要更新原始位置）
		if card.has_method("set_base_transform"):
			card.set_base_transform(pos - position, rot)
