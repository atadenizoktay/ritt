tool
extends Sprite


"""
	Node: SpriteStackParent
	Type: Entity
	Description: This script controls the stacking behavior of sprites in the
	game. Stacked sprites simulate an isometric 3D effect for entities in run
	time.
"""


const _DROP_IN_INITIAL_Y_OFFSET: int = -320

export(bool) var _is_rendering_sprites: bool = false setget \
		_set_is_rendering_sprites
export(bool) var _is_rotating_sprites: bool = true setget \
		_set_is_rotating_sprites
export(Color) var _sprite_inital_modulation: Color = Color.white
export(float, 0.5, 3.2, 0.1) var _stack_position_offset_multiplier: float = 1
export(int, -100, 100, 1) var _sprites_y_offset: int = 0
export(float, 0.2, 3.2, 0.1) var _stack_drop_in_duration: float = 1.2
export(float, 0.1, 0.8, 0.01) var \
		_stack_last_sprite_minimum_drop_in_duration: float = 0.2
export(float, 0.2, 3.2, 0.1) var _stack_fade_in_out_duration: float = 1.2
export(float, 0.1, 0.8, 0.01) var \
		_stack_last_sprite_minimum_fade_in_out_duration: float = 0.2

var reference_sprite: Sprite = null
var top_sprite: Sprite = null
var _sprites_are_rendered: bool = false

onready var StackTween: Tween = $Tween


func _ready() -> void:
	_render_sprites()
	

func _process(delta: float) -> void:
	_control_stack_preview_rotation(delta)
	
	
func _control_stack_preview_rotation(delta: float) -> void:
	if _is_rotating_sprites:
		for child in get_children():
			if child.get("rotation") != null:
				child.rotation += delta
	

func control_children_rotation(rotate_to: float) -> void:
	for child in get_children():
		if child.get("rotation") != null:
			child.rotation = rotate_to
	
		
func _clear_sprites() -> void:
	if not _sprites_are_rendered:
		return
		
	for child in get_children():
		if child is Sprite:
			child.queue_free()
	_sprites_are_rendered = false
	

func _render_sprites() -> void:
	if _sprites_are_rendered:
		return
		
	for i in range(0, hframes):
		var new_sprite: Sprite = Sprite.new()
		new_sprite.modulate = _sprite_inital_modulation
		new_sprite.texture = texture
		new_sprite.hframes = hframes
		new_sprite.frame = i
		new_sprite.position.y = -i * _stack_position_offset_multiplier
		new_sprite.offset.y = _sprites_y_offset
		add_child(new_sprite)
		reference_sprite = new_sprite if i == 0 else new_sprite
		top_sprite = new_sprite if i == hframes - 1 else top_sprite
	_sprites_are_rendered = true


func drop_in_sprites() -> void:
	var delay: float = 0
	var delay_increment: float = _stack_drop_in_duration / hframes
	for child in get_children():
		if child is Sprite:
			var old_offset: Vector2 = child.offset
			child.offset.y = _DROP_IN_INITIAL_Y_OFFSET
			StackTween.interpolate_property(child, "offset", \
					child.offset, old_offset, \
					max(_stack_drop_in_duration - delay, \
					_stack_last_sprite_minimum_drop_in_duration), \
					Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
			StackTween.start()
			delay += delay_increment
	visible = true
	
	
func fade_in_out_sprites(out: bool) -> void:
	var delay: float = 0
	var delay_increment: float = _stack_fade_in_out_duration / hframes
	for child in get_children():
		if child is Sprite:
			StackTween.interpolate_property(child, "modulate", child.modulate, \
					Color.transparent if out else Color.white, \
					max(_stack_fade_in_out_duration - delay, \
					_stack_last_sprite_minimum_fade_in_out_duration), \
					Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
			StackTween.start()
			delay += delay_increment
			

func _set_is_rendering_sprites(rendering: bool) -> void:
	_is_rendering_sprites = rendering
	if _is_rendering_sprites:
		_render_sprites()
		return
	_clear_sprites()


func _set_is_rotating_sprites(rotating: bool) -> void:
	_is_rotating_sprites = rotating
	if not rotating:
		for child in get_children():
			if child is Sprite:
				child.rotation = 0
