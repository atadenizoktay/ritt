tool
extends Sprite


"""
	Node: SpriteStackParent
	Type: Entity
	Description: This script controls the stacking behavior of sprites in the
	game. Stacked sprites simulate an isometric 3D effect for entities in run
	time.
"""


export(bool) var _is_rendering_sprites: bool = false setget \
		_set_is_rendering_sprites
export(bool) var _is_rotating_sprites: bool = true setget \
		_set_is_rotating_sprites
export(float, 0.5, 3.2, 0.1) var _stack_position_offset_multiplier: float = 1


func _ready() -> void:
	_render_sprites()
	

func _process(delta: float) -> void:
	_control_stack_preview_rotation(delta)
	
	
func _control_stack_preview_rotation(delta: float) -> void:
	if _is_rotating_sprites:
		for sprite in get_children():
			sprite.rotation += delta
	

func control_sprites_rotation(rotate_to: float) -> void:
	for sprite in get_children():
		sprite.rotation = rotate_to
		
		
func _clear_sprites() -> void:
	for sprite in get_children():
		sprite.queue_free()
	

func _render_sprites() -> void:
	for i in range(0, hframes):
		var new_sprite: Sprite = Sprite.new()
		new_sprite.texture = texture
		new_sprite.hframes = hframes
		new_sprite.frame = i
		new_sprite.position.y = -i * _stack_position_offset_multiplier
		add_child(new_sprite)


func _set_is_rendering_sprites(rendering: bool) -> void:
	_is_rendering_sprites = rendering
	_render_sprites() if _is_rendering_sprites else _clear_sprites()


func _set_is_rotating_sprites(rotating: bool) -> void:
	_is_rotating_sprites = rotating
	if not rotating:
		for sprite in get_children():
				sprite.rotation = 0
