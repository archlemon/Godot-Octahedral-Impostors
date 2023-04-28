@tool
extends Node2D

var processed_image: Image = null
var _alpha_image: Image = null

func _dilatate_image(alpha_mask: Image, image: Image):
	var tex: ImageTexture = ImageTexture.new()
	var alpha_tex: ImageTexture = ImageTexture.new()
	tex.flags = 0
	alpha_tex.flags = 0
	tex.create_from_image(image)
	alpha_tex.create_from_image(alpha_mask)
	$DilateViewport.size = image.get_size()
	$DilateViewport/tex.texture = tex
	$DilateViewport/tex.material.set_shader_param("u_alpha_tex", alpha_tex)
	$DilateViewport.transparent_bg = true
	$DilateViewport.render_target_update_mode = Viewport.PROCESS_MODE_ALWAYS
	$DilateViewport.render_target_v_flip = true
	$DilateViewport.update_worlds()
	print("DilateViewportSize: ", $DilateViewport.size)

	var viewport_texture = $DilateViewport.get_texture()
	await RenderingServer.frame_post_draw
	viewport_texture.flags = 0
	self.processed_image = viewport_texture.get_data()


func dilatate_mask(alpha_mask: Image, image: Image):
	$DilateViewport/tex.material.set_shader_param("u_alpha_overwrite", true)
	return await self._dilatate_image(alpha_mask, image)


func dilatate(image: Image, use_as_alpha = false):
	if use_as_alpha:
		_alpha_image = image
	$DilateViewport/tex.material.set_shader_param("u_alpha_overwrite", false)
	return await self._dilatate_image(_alpha_image, image)
