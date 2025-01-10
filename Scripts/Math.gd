extends Node


func calculate_damage(base_damage : float, attack : float, defense : float):
	var total_damage = base_damage * (attack / (attack + defense))
	return round(total_damage)
