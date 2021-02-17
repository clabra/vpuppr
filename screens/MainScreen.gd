extends Spatial

const DEV_UI: Resource = preload("res://utils/gui/DevUI.tscn")

const MODEL_SCREEN: Resource = preload("res://screens/ModelDisplayScreen.tscn")

var debug: bool = true

var current_model_path: String = ""
export(AppManager.ModelType) var current_model_type = AppManager.ModelType.GENERIC

var model_display_screen: Spatial

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	get_viewport().transparent_bg = true
	OS.window_per_pixel_transparency_enabled = true
	
	if OS.has_feature("standalone"):
		debug = false
	if not OS.is_debug_build():
		debug = false
	
	AppManager.connect("file_to_load_changed", self, "_on_file_to_load_changed")
	
	model_display_screen = MODEL_SCREEN.instance()
	model_display_screen.model_type = current_model_type
	add_child(model_display_screen)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel") and debug):
		get_tree().quit()

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_file_to_load_changed(file_path: String, file_type: int) -> void:
	current_model_path = file_path
	current_model_type = file_type
	_clean_load_model_display_screen()

###############################################################################
# Private functions                                                           #
###############################################################################

func _clean_load_model_display_screen() -> void:
	model_display_screen.free()
	model_display_screen = MODEL_SCREEN.instance()
	model_display_screen.model_type = current_model_type
	model_display_screen.model_resource_path = current_model_path
	add_child(model_display_screen)

###############################################################################
# Public functions                                                            #
###############################################################################

