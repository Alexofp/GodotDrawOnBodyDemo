A simple janky demo that allows you to draw on a body in real time. Uses godot 4.2

### Demo (Slightly nsfw)

https://github.com/Alexofp/GodotDrawOnBodyDemo/assets/14040378/fc29bc05-b61c-41b2-965a-553961265df0


### How it works:
1. I render the body into a separate viewport with a special shader that maps UV coordinates to R and G channels (top left texture). Since the viewport is HDR, it gives enough precision
2. I sample that viewport's texture under the mouse cursor and read the color. This is how I get the UV coordinate on the body
3. I draw a small black circle on a blank image using these coordinates (bottom right texture). Then I convert that image into a texture and apply it on top of the model inside the shader

### Problems
1. Probably terrible performance since I have to constantly upload a new texture onto the gpu to show what you drew
2. UV seams of the body are quite visible when you draw over them
