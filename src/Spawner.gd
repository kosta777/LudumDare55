class_name Spawner extends Object

func random_elem(dict_prob):
	var total_weight = dict_prob.values().reduce(func(x, y): return x + y, 0)
	var random = randi_range(0, total_weight - 1)
	var cum_weight = 0
	var elem = null
	for key in dict_prob.keys():
		cum_weight += dict_prob[key]
		if random < cum_weight:
			return key
		
func spawn_portal1():
	var dict_prob = {
		preload("res://scenes/ennemy.tscn"): 1,
		preload("res://scenes/raw_material_node.tscn") : 2,
	}
	
	return random_elem(dict_prob)
	
