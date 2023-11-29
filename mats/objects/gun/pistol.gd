extends Node2D
@export var activated:bool
@export_flags_2d_physics var collosion_with
@export var bullet_scene:PackedScene
@export var automat:bool
@export var free_bullets:bool=false#inf. bullets
@export_range(1,99999) var max_value:float
@onready var cur_value=max_value
@export_range(0.001,99999) var cost_value:float=1
@export_range(-90,90) var bullet_speed:float
@export_range(0,360) var spread:float
@export_range(0.001,99) var reload_time:float=0
var cur_reload_time:float=0
@export_range(0.001,999) var shoot_speed:float=0
var cur_shoot_time:float=0
var reloading:bool=false
var reload:bool=false
var shooted:bool=false
func shoot():
	var b=bullet_scene.instantiate()
	b.del_rad=10000
	b.start_pos=$bsp.global_position
	b.global_rotation_degrees=global_rotation_degrees
	b.move_to=fnc.move(global_rotation_degrees+randf_range(-spread,spread))
	b.speed=bullet_speed
	b.collision_layer=collosion_with
	b.add_to_group("energy")
	get_tree().current_scene.get_node("world").add_child(b)
	cur_value-=1*int(free_bullets)
func _physics_process(delta):
	rotation_degrees=fnc.angle(get_global_mouse_position()-global_position)
	cur_shoot_time+=delta
	if automat:
		if activated and (cur_value>0 or free_bullets):
			if cur_shoot_time>=shoot_speed:
				shoot()
				cur_shoot_time=0
	else:
		if activated:
			if shooted==false and cur_shoot_time>=shoot_speed:
				shoot()
				cur_shoot_time=0
				shooted=true
		else:
			shooted=false
	if reload and !reloading:
		reloading=true
		reload=false
	if reloading:
		cur_value+=(max_value-cur_value)*reload_time*delta
		if cur_value>=max_value:
			reloading=false
			cur_value=max_value
