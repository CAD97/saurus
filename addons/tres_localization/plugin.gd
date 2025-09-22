@tool
extends EditorPlugin


const SerializedResourceEditorTranslationParserPlugin = preload("uid://b7iwr2og71c6q") # serialized_resource_editor_translation_parser_plugin.gd
var _parser_plugin: EditorTranslationParserPlugin


func _enter_tree() -> void:
	_parser_plugin = SerializedResourceEditorTranslationParserPlugin.new()
	add_translation_parser_plugin(_parser_plugin)


func _exit_tree() -> void:
	remove_translation_parser_plugin(_parser_plugin)
	_parser_plugin = null
