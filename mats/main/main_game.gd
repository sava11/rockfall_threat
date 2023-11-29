extends Node2D

func player_max_health_changed(v):
	$cl/ui/stats/hp.max_value=v


func player_health_changed(v):
	$cl/ui/stats/hp.value=v
