extends Node
const fformat="SN"
var fname="data0"
const mres="user://"
const save_path="saves/"
var sn={}

func _ready():
	var d=DirAccess.open(mres)
	d.make_dir(save_path)

func save_file_data():
	for e in get_tree().get_nodes_in_group("SN"):
		_save_node(e.save_data())
	var save_game := FileAccess.open(mres+save_path+fname+"."+fformat, FileAccess.WRITE)
	save_game.store_line(JSON.stringify(sn))
	save_game.close()
func load_file_data():
	if (FileAccess.file_exists(mres+save_path+fname+"."+fformat)):
		var save_game := FileAccess.open(mres+save_path+fname+"."+fformat, FileAccess.READ)
		if save_game.get_length()!=0:
			sn=JSON.parse_string(save_game.get_line())
			for e in sn.keys():
				if e==sn[e].current_path:
					if get_tree().current_scene.get_node_or_null(e)!=null:
						get_tree().current_scene.get_node(e).load_data(e,sn[e])
				else:
					var spath:PackedStringArray=sn[e].current_path.split("/")
					spath.remove_at(spath.size()-1)
					var cpath=""
					for s in spath:
						cpath+=s+"/"
					if get_tree().current_scene.get_node_or_null(cpath)!=null:
						var node=load(sn[e].file).instantiate()
						get_node(cpath).add_child(node)
						node.load_data(sn[e])
		else:
			print("save is clear")
		save_game.close()
	else:
		print("save isn't exists")


func _save_node(d:Dictionary):
	sn.merge(d,true)
func _load_node(n,path):
	var d=sn[path]
	n.load_data(path,d)
