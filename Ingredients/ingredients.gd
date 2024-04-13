class_name Ingredients
extends Node

enum Type {
		BLACK_SOUL,
		RED_SOUL,
		PURPLE_SOUL
	}
	
const INGREDIENT_NAME := {
	Type.BLACK_SOUL: "Black soul",
	Type.RED_SOUL: "Red soul",
	Type.PURPLE_SOUL: "Purple soul"
}

const INGREDIENT_ICON := {
	Type.BLACK_SOUL: preload ("res://sprites/Demons/soul.png"),
	Type.RED_SOUL: preload ("res://sprites/Demons/soul.png"),
	Type.PURPLE_SOUL: preload ("res://sprites/Demons/soul.png")
}
