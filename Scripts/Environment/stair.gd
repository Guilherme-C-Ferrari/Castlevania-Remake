extends Node2D







func _on_up_area_body_entered(body: Node2D) -> void:
	pass
	#setar player em posicao de subir escada
	#Se UP press o player vai a até a posição inicial


func _on_up_area_body_exited(body: Node2D) -> void:
	pass
	#setar player em não posicao de subir escada


func _on_down_area_body_entered(body: Node2D) -> void:
	pass 
	#setar player em posicao de descer escada
	#Se DOWN press o player vai a até a posição inicial

func _on_down_area_body_exited(body: Node2D) -> void:
	pass
	#setar player em não posicao de descer escada
