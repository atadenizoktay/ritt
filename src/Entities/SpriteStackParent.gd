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
export(float, 0.5, 3.2, 0.1) var _stack_offset: float = 1


func _ready() -> void:
	_render_sprites()
	

func _clear_sprites() -> void:
	for sprite in get_children():
		sprite.queue_free()
	

func _render_sprites() -> void:
	for i in range(0, hframes):
		var new_sprite: Sprite = Sprite.new()
		new_sprite.texture = texture
		new_sprite.hframes = hframes
		new_sprite.frame = i
		new_sprite.offset.y = -i * _stack_offset
		add_child(new_sprite)


func _set_is_rendering_sprites(rendering: bool) -> void:
	_is_rendering_sprites = rendering
	_render_sprites() if _is_rendering_sprites else _clear_sprites()
