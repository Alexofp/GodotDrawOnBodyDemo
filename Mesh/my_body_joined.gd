extends Node3D


func _process(delta):
	if(Input.is_key_pressed(KEY_1) && $AnimationPlayer.current_animation != "IdleSimple"):
		$AnimationPlayer.play("IdleSimple")
	if(Input.is_key_pressed(KEY_2) && $AnimationPlayer.current_animation != "WalkSimple"):
		$AnimationPlayer.play("WalkSimple")
	if(Input.is_key_pressed(KEY_3) && $AnimationPlayer.current_animation != "APose"):
		$AnimationPlayer.play("APose")
