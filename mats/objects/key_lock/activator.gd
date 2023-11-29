extends Node2D
@export var drawing:bool=true
@export var positive:Color=Color("00aa00")
@export var negative:Color=Color("aa0000")
@export var error:Color=Color("bb4f00")
@export var activate:bool=false
var blocked:bool=false
@export var reset_when_blocked:bool=false
@export var reset_value:bool=false
@onready var activated:bool=activate
var mechanical_active:bool=false
signal _load_data(node:Object,path:String)
signal save_data_changed(dict:Dictionary)
signal active(active:bool)
var original_path:String=""
func save_data():
	return {original_path:{
			"current_path":str(get_path()),
			"file":self.scene_file_path,
			"activated":activated,
		}}
func load_data(origin,n):
	original_path=origin
	activated=n["activated"]
	mechanical_active=activated
func _ready():
	$color.global_position=get_parent().global_position
	if original_path=="":original_path=str(get_path())
	connect("save_data_changed",Callable(sls,"_save_node"))
	connect("_load_data",Callable(sls,"_load_node"))
	activated=activate
	if !sls.sn.has(str(get_path())):
		emit_signal("save_data_changed",save_data())
		if activate==true:activated=!activate
	else:
		emit_signal("_load_data",self,str(get_path()))
func act():if !activated:activate=true
func deact():if activated:activate=true
func _process(delta):
	$color.visible=drawing
	if activate and !blocked:
		if activated==false:
			activated=true
			mechanical_active=activated
		else:
			activated=false
			mechanical_active=activated
		emit_signal("save_data_changed",save_data())
		activate=false
	else:
		activate=false
	if reset_when_blocked and blocked:
		activated=reset_value
		emit_signal("save_data_changed",save_data())
	if !blocked and activated!=mechanical_active:activate=!mechanical_active
	if blocked:$color.color=error
	elif activated:$color.color=positive
	elif !activated:$color.color=negative


func _on_lock_activated(active):
	blocked=active
