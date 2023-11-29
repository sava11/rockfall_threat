extends Node
@export var keys_paths:PackedStringArray
var count_active_keys=0
var count_keys=0 
var was_activated=false
signal _load_data(node:Object,path:String)
signal save_data_changed(dict:Dictionary)
signal activated(active:bool)
var original_path:String=""
func save_data():
	return {
		original_path:{
			"current_path":str(get_path()),
			"file":self.scene_file_path,
		}
	}
func load_data(origin,n):
	original_path=origin
func update_acive():
	count_active_keys=0
	for e in range(count_keys):
		if sls.sn.has(keys_paths[e])==true:
			count_active_keys+=int(sls.sn[keys_paths[e]].get("activated"))
func _ready():
	if original_path=="":
		original_path=str(get_path())
	connect("save_data_changed",Callable(sls,"_save_node"))
	connect("_load_data",Callable(sls,"_load_node"))
	if !sls.sn.has(str(get_path())):
		emit_signal("save_data_changed",save_data())
	else:
		emit_signal("_load_data",self,str(get_path()))
	#emit_signal("activated",false)
	count_keys=len(keys_paths)
	#update_acive()
func _physics_process(delta):
	update_acive()
func _process(delta):
	var active=count_keys>0 and count_keys==count_active_keys
	if active and was_activated!=active:
		was_activated=active
		emit_signal("activated",true)
		emit_signal("save_data_changed",save_data())
	if !active and was_activated!=active:
		was_activated=active
		emit_signal("activated",false)
		emit_signal("save_data_changed",save_data())
