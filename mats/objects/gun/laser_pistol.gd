extends Node2D
@export var activated:bool
@export var free_use:bool=false
@export_range(1,99999) var max_value:float
@onready var cur_value=max_value
@export_range(0,99999) var cost_value:float=1
@export_range(0.001,99) var reload_time:float=0
var cur_reload_time:float=0
var reloading:bool=false
var reload:bool=false
@onready var lsr=$laser
func _physics_process(delta):
	rotation_degrees=fnc.angle(get_global_mouse_position()-global_position)
	if activated and cur_value>0 and !reloading:
		$laser._on_lock_activated(false)
		cur_value-=cost_value*delta*int(!free_use)
	else:
		$laser._on_lock_activated(true)
	if reload and !reloading:
		reloading=true
		reload=false
	if reloading:
		cur_value+=(max_value-cur_value)*reload_time*delta
		if cur_value>=max_value:
			reloading=false
			cur_value=max_value
