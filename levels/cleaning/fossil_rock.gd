extends Node2D

@export_range(1.0, 100.0, 0.2) var damage_granularity: float = 5.0;

var _layer1_mask: Image
var _layer1_mask_tex: ImageTexture

var _mask_scale: Vector2

static func _init_mask_material(sprite: Sprite2D, tex: ImageTexture) -> void:
	assert(sprite.material is ShaderMaterial);
	var mat: ShaderMaterial = sprite.material.duplicate();
	mat.set_shader_parameter("mask_texture", tex);
	sprite.material = mat

func _ready() -> void:
	var aspect := float(%Layer1.texture.get_width()) / float(%Layer1.texture.get_height());
	_mask_scale = Vector2(damage_granularity * aspect, damage_granularity);
	var mask_res := Vector2i(_mask_scale.ceil());
	
	_layer1_mask = Image.create_empty(mask_res.x, mask_res.y, false, Image.FORMAT_R8);
	_layer1_mask.fill(Color.WHITE);
	_layer1_mask_tex = ImageTexture.create_from_image(_layer1_mask);
	_init_mask_material(%Layer1, _layer1_mask_tex)
	
	for y in range(mask_res.y):
		for x in range(mask_res.x):
			if randf() <= 0.3:
				_layer1_mask.set_pixel(x, y, Color.BLACK);
	_layer1_mask_tex.update(_layer1_mask)
	
