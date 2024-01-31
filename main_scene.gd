extends Node3D

@onready var camera_center = $CameraCenter
@onready var camera_center_2 = $UVRenderViewport/CameraCenter2

@onready var texture_rect = $CanvasLayer/TextureRect

var drawImage:Image
@export var bodyMat : ShaderMaterial

func _ready():
	drawImage = Image.create(512, 512, true, Image.FORMAT_RGBA8)

var oldMousePosition:Vector2
var oldDrawImagePosition:Vector2i
func _process(delta):
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		var aspect = get_viewport().get_visible_rect().size.x / get_viewport().get_visible_rect().size.y
		var scaledPosition = get_viewport().get_mouse_position() / get_viewport().get_visible_rect().size.y - Vector2((aspect-1.0)/2.0, 0.0)
		#print(scaledPosition)
		var texture:ViewportTexture = texture_rect.texture
		var uvTexturePosition = scaledPosition * texture.get_size()
		var UVcolor:Color = texture.get_image().get_pixel(uvTexturePosition.x, uvTexturePosition.y)
		#print(UVcolor)
		
		var drawImagePosition = Vector2i(Vector2(drawImage.get_size()) * Vector2(UVcolor.r, UVcolor.g))
		drawImagePosition.x = clamp(drawImagePosition.x, 0, drawImage.get_size().x)
		drawImagePosition.y = clamp(drawImagePosition.y, 0, drawImage.get_size().y)
		
		var distance = Vector2(drawImagePosition).distance_to(Vector2(oldDrawImagePosition))
		if(distance < 10):
			var howManyStrokes = int(distance) + 1
			for _i in range(howManyStrokes):
				var pos = float(_i) / float(howManyStrokes)
				var deltaDrawPos:Vector2i = drawImagePosition - oldDrawImagePosition
				var finalDrawPos = oldDrawImagePosition + Vector2i(deltaDrawPos * pos)
				drawImage.blend_rect(preload("res://brush.png"), Rect2i(0, 0, 3, 3), Vector2i(finalDrawPos.x, finalDrawPos.y))
			#drawImage.fill_rect(Rect2i(drawImagePosition.x, drawImagePosition.y, 3, 3), Color.BLACK)
			#drawImage.blend_rect(preload("res://brush.png"), Rect2i(0, 0, 3, 3), Vector2i(drawImagePosition.x, drawImagePosition.y))
			
		oldDrawImagePosition = drawImagePosition
		
		var newTextureImage = ImageTexture.create_from_image(drawImage)
		bodyMat.set_shader_parameter("texture_albedo_add", newTextureImage)
		$CanvasLayer/TextureRect2.texture = newTextureImage
	else:
		oldDrawImagePosition = Vector2i()

func _input(event):
	# Camera controls
	if event is InputEventMouseMotion:
		if(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
			var delta = event.position - oldMousePosition
			camera_center.rotate(Vector3.UP, -delta.x / 100.0)
			camera_center_2.rotation = camera_center.rotation
			
			camera_center.position.y += delta.y/300.0
			camera_center_2.position = camera_center.position
		oldMousePosition = event.position
		
	if event is InputEventMouseButton:
		if(Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP)):
			$CameraCenter/Camera3D.fov -= 5
			$UVRenderViewport/CameraCenter2/Camera3D.fov = $CameraCenter/Camera3D.fov
		if(Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN)):
			$CameraCenter/Camera3D.fov += 5
			$UVRenderViewport/CameraCenter2/Camera3D.fov = $CameraCenter/Camera3D.fov
