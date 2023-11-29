extends CharacterBody2D
@export_range(0,9999999) var speed_vel:float=100
@export_range(0,9999999) var acc:float=100
@export_range(0,9999999) var deacc:float=100
@export_range(0,9999999) var jump_power:float=100
@export_range(0,9999999) var gr_power:float=98
@export_range(1,9999) var MultiJumpMaxValue:int=1
@onready var hb=$hurt_box
@onready var gu=$get_up
signal _load_data(node:Object,path:String)
signal save_data_changed(dict:Dictionary)
var manyjumpvalue=0
var gvec:Vector2=Vector2.ZERO
var original_path:String=""

func save_data():
	return {
		original_path:{
			"current_path":str(get_path()),
			"file":self.scene_file_path,
			"posx":position.x,
			"posy":position.y,
			"rot_deg":rotation_degrees,
			"mjmv":MultiJumpMaxValue,
			"die":die,
		}
	}
func load_data(origin,n):
	original_path=origin
	position=Vector2(n.posx,n.posy)
	rotation_degrees=n.rot_deg
	transform.origin=Vector2(n.posx,n.posy)
	MultiJumpMaxValue=n.mjmv
	die=n.die
func get_gravity():
	return gr_power
func _ready():
	if original_path=="":original_path=str(get_path())
	connect("save_data_changed",Callable(sls,"_save_node"))
	connect("_load_data",Callable(sls,"_load_node"))
	if !sls.sn.has(str(get_path())):emit_signal("save_data_changed",save_data())
	else:emit_signal("_load_data",self,str(get_path()))
var die:bool=false
func _physics_process(delta):
	if die==false:
		if Input.is_action_just_pressed("save_data"):
			sls.save_file_data()
			print("сохраняю")
		if Input.is_action_just_pressed("load_data"):
			sls.load_file_data()
			print("загружается")
		var mvd=Input.get_vector("left","right","up","down")
		if mvd.x!=0:gu.position.x=mvd.x*25
		var wl=0
		var ground=is_on_floor()
		var jpress=Input.is_action_just_pressed("jump")
		var jreleased=Input.is_action_just_released("jump")
					
		if mvd.x==wl and wl!=0:
			mvd.x=0
		if (ground or wl!=0) and velocity.y>=0:
			manyjumpvalue=0
		if ground:
			if mvd.x!=0:
				velocity.x=move_toward(velocity.x,mvd.x*speed_vel,acc*delta)
			else:
				var xv = abs(velocity.x)
				xv -= deacc * delta
				if xv < 0:xv = 0
				velocity.x = sign(velocity.x) * xv
		else:
			if mvd.x!=0:
				velocity.x=move_toward(velocity.x,mvd.x*speed_vel,acc/2*delta)
			else:
				var xv = abs(velocity.x)
				xv -= deacc/2 * delta
				if xv < 0:xv = 0
				velocity.x = sign(velocity.x) * xv
		
		if gu.is_colliding():
			$get_up/full_height.position.y=gu.to_local(gu.get_collision_point()).y
			if !$get_up/full_height.is_colliding() and !ground and velocity.y>0:
				global_position=gu.get_collision_point()
				velocity=Vector2.ZERO
		else:
			$get_up/full_height.position.y=gu.target_position.y
		if jpress and manyjumpvalue<MultiJumpMaxValue :
			velocity.y = 0
			velocity.y-=jump_power
			manyjumpvalue+=1
		if jreleased and velocity.y < 0:
			velocity.y -= (0.5 * velocity.y)
		if !ground:
			velocity.y+=gr_power*delta
		move_and_slide()
	else:
		
		if Input.is_action_just_pressed("save_data"):
			print("Вы мертвы, какой 'выполни сохранение'")
		if Input.is_action_just_pressed("load_data"):
			sls.load_file_data()
			print("загружается")


func _on_hurt_box_no_he():
	die=true
