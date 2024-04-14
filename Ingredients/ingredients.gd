class_name Ingredients
extends Node

enum Type {
		BLACK_SOUL, 
		RED_SOUL, 
		PURPLE_SOUL,
		HORNS,
		WINGS
	}
	
const INGREDIENT_NAME := {
	Type.BLACK_SOUL : "Black soul",
	Type.RED_SOUL : "Red soul",
	Type.PURPLE_SOUL : "Purple soul",
	Type.HORNS : "Horns",
	Type.WINGS : "Wings"
}

const INGREDIENT_ICON := {
	Type.BLACK_SOUL : preload("res://sprites/Demons/soul.png"),
	Type.RED_SOUL : preload("res://sprites/Demons/soul.png"),
	Type.PURPLE_SOUL : preload("res://sprites/Demons/soul.png"),
	Type.HORNS : preload("res://material_texture/horn.tres"),
	Type.WINGS : preload("res://material_texture/wing.tres")
}
