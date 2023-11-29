extends Node

var rnd=RandomNumberGenerator.new()
func get_hero():
	return get_tree().current_scene.get_node("world/player")
func get_world_node():
	return get_tree().current_scene.get_node("world")
func get_camera():
	return get_tree().current_scene.get_node("cam")
func get_view_win():
	return get_viewport().get_visible_rect().size
func get_prkt_win():
	return Vector2(ProjectSettings.get("display/window/size/viewport_width"),ProjectSettings.get("display/window/size/viewport_height"))
func in_area(p,point):
	var result = false;
	var size=len(p)
	var j = size - 1;
	for i  in range(0,size):
		if ( (p[i].y < point.y && p[j].y >= point.y or p[j].y < point.y && p[i].y >= point.y) and (p[i].x + (point.y - p[i].y) / (p[j].y - p[i].y) * (p[j].x - p[i].x) < point.x) ):
			result = !result;
		j = i;
	return result
func get_area(pol):
	var area=0
	for i in range(0, len(pol) -1):
		area+=pol[i].x*pol[i+1].y-pol[i+1].x*pol[i].y
	return abs(area)
func _rotate_vec(vec:Vector2,ang:float):
	return move(rad_to_deg(angle(vec))+ang)*_sqrt(vec)
func angle(V:Vector2):
	return rad_to_deg(-atan2(-V.y,V.x))
func _sqrt(v:Vector2):
	return sqrt(v.x*v.x+v.y*v.y)
func sqrtV(v:Vector2):
	return Vector2(sqrt(v.x),sqrt(v.y))
func move(ang):
	return Vector2(cos(deg_to_rad(ang)),sin(deg_to_rad(ang)))
func jos(a,b):
	if b!=0:
		return b*round(a/b)
	else:return 0
func circ(a,mn,mx):
	return abs(mx+a)%abs(mx)+mn
func i_search(a,i):
	var inte=0
	for k in a:
		if k==i:
			return inte
		inte+=1
	return -1
static func sum(array):
	var sum = 0.0
	for element in array:
		sum += element
	return sum

func change_parent(where,what):
	what.get_parent().call_deferred("remove_child",what)
	where.call_deferred("add_child",what)
	await get_tree().process_frame


func get_ang_move(angle:float,ex:float):
	var ang1=abs(ex)
	var le=int(360/ang1)
	var ang=int(abs(angle)+180+ang1/2)%360
	if ang>=0:
		for e in range(0,le):
			if ang>=e*ang1 and ang<(e+1)*ang1:
				return e
func _with_dific(v:float,dific:float):
	return v+v*dific
func _with_chance(chance:float):
	if rnd.randf_range(0,1)>1-chance:
		return true
	return false
func _with_chance_custom_values(chance:float,Tvalue,Fvalue):
	if rnd.randf_range(0,1)>1-chance:
		return Tvalue
	return Fvalue
func _with_chance_ulti(chances=[0.5,0.5]):
	var sum=sum(chances)
	var cur_value=rnd.randf_range(0,sum)
	var prefix:float=0
	if sum>0:
		for e in range(chances.size()):
			if cur_value>=prefix and cur_value<prefix+chances[e]:
				return e
			prefix+=chances[e]
	return -1
func find_betwen_lines(point,lines:PackedVector2Array):
	var curent=[]
	for e in range(lines.size()):
		if lines[e].x<=point and lines[e].y>point:
			curent.append(e)
	
	if curent==[]:
		return -1
	else:
		return curent[rnd.randi_range(0,curent.size()-1)]

func rec_duplic(d:Dictionary):
	var out_d={}
	for e in d.keys():
		if typeof(d[e])==TYPE_DICTIONARY:
			out_d.merge({e:rec_duplic(d[e].duplicate())})
		else:
			out_d.merge({e:d[e]})
	return out_d

func setter(itm,data:Dictionary):
	for e in data.keys():
		if e.contains("/"):
			var me=e
			if e.begins_with("/"):me=e.erase(0)
			var str=me.split(".")
			var n=itm.get_node(str[0])
			if is_instance_valid(n):
				if !str[1].contains("()"):n.set(str[1],data[e])
				else:
					var var_type=typeof(data[e])
					var callable=Callable(n,str[1].split("()")[0])
					if var_type!=TYPE_NIL:
						if var_type!=TYPE_ARRAY:
							callable=callable.bindv([data[e]])
						else:
							callable=callable.bindv(data[e])
					callable.call()
			else:
				printerr("can't set/call parametr ",e," with ",data[e])
		else:
			var str=e.split(".")[len(e.split("."))-1]
			if is_instance_valid(itm):
				if !str.contains("()"):itm.set(str,data[e])
				else:
					var var_type=typeof(data[e])
					var callable=Callable(itm,str.split("()")[0])
					if var_type!=TYPE_NIL:
						if var_type!=TYPE_ARRAY:
							callable=callable.bindv([data[e]])
						else:
							callable=callable.bindv(data[e])
					callable.call()
			else:
				printerr("can't set/call parametr ",e," with ",data[e])


func _ready():
	rnd.randomize()
