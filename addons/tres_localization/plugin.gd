@tool
extends EditorPlugin

var _parser_plugin: EditorTranslationParserPlugin


func _enter_tree() -> void:
	_parser_plugin = load("res://addons/tres_localization/serialized_resource_editor_translation_parser_plugin.gd").new()
	add_translation_parser_plugin(_parser_plugin)


func _exit_tree() -> void:
	remove_translation_parser_plugin(_parser_plugin)
	_parser_plugin = null
