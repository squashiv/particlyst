@tool
#class_name ParticlystDragContainer
extends Container

# Code from HungryProton's ProtonScatter https://github.com/HungryProton/scatter

# DragContainer
# Custom containner similar to a VBoxContainer, but the user can rearrange the
# children order via drag and drop. This is only used in the inspector plugin
# for the modifier stack and won't work with arbitrary control nodes.

signal child_moved(last_index: int, new_index: int)

var _separation: int = 0
var _drag_offset: Vector2
var _dragged_child: Control
var _old_index: int
var _new_index: int
var _map := [] # Stores the y top position of each child in the stack

func _ready() -> void:
	_separation = get_theme_constant("separation", "VBoxContainer")

func _notification(p_what: int) -> void:
	if p_what == NOTIFICATION_SORT_CHILDREN or p_what == NOTIFICATION_RESIZED or p_what == NOTIFICATION_DRAG_END:
		_update_layout()

func _can_drop_data(p_at_position: Vector2, p_data: Variant) -> bool:
	if typeof(p_data) != TYPE_OBJECT:
		return false
	var control := p_data as Control
	if control == null:
		return false
	if control.get_parent() != self:
		return false
	
	# Drag just started
	if _dragged_child == null:
		_dragged_child = control
		_drag_offset = p_at_position - control.position
		_old_index = control.get_index()
		_new_index = _old_index
	
	# Dragged control only follow the y mouse position
	control.position.y = p_at_position.y - _drag_offset.y
	
	# Check if the children order should be changed
	var computed_index := 0
	for pos_y in _map:
		if pos_y > control.position.y - 16:
			break
		computed_index += 1
	
	# Prevents edge case when dragging the last item below its current position
	computed_index = clampi(computed_index, 0, get_child_count() - 1)
	
	if computed_index != control.get_index():
		move_child(control, computed_index)
		_new_index = computed_index
	
	return true

# Called once at the end of the drag
func _drop_data(p_at_position: Vector2, p_data: Variant) -> void:
	_drag_offset = Vector2.ZERO
	_dragged_child = null
	_update_layout()
	
	if _old_index != _new_index:
		child_moved.emit(_old_index, _new_index)

# Detects if the user drops the children outside the container and treats it
# as if the drop happened the moment the mouse left the container.
func _unhandled_input(p_event: InputEvent) -> void:
	if not _dragged_child:
		return
	
	if p_event is InputEventMouseButton:
		if not p_event.pressed:
			_drop_data(_dragged_child.position, _dragged_child)

func _update_layout() -> void:
	_map.clear()
	var offset := Vector2.ZERO
	
	for c: Control in get_children():
		if c == null:
			continue
		
		_map.push_back(offset.y)
		var child_min_size := c.get_combined_minimum_size()
		var possible_space := Rect2(offset, Vector2(size.x, child_min_size.y))
		
		if c != _dragged_child:
			fit_child_in_rect(c, possible_space)
			
		offset.y += c.size.y + _separation
	
	custom_minimum_size.y = offset.y - _separation
