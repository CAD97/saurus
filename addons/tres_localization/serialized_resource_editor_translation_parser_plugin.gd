@tool
class_name SerializedResourceEditorTranslationParserPlugin extends EditorTranslationParserPlugin


func _parse_file(path: String) -> Array[PackedStringArray]:
	var res := load(path)
	if not res:
		push_warning("%s is not a Resource (SerializedResourceEditorTranslationParserPlugin)" % res)
		return []
	
	var msgs: Array[PackedStringArray] = []
	var props := res.get_property_list()
	for prop in props:
		if prop["type"] == TYPE_STRING or prop["type"] == TYPE_STRING_NAME:
			if prop["hint"] == PROPERTY_HINT_LOCALIZABLE_STRING:
				var msgid := res.get(prop["name"])
				var msgtxt = msgid
				msgs.append(PackedStringArray([msgid, msgtxt]))
	
	return msgs


func _get_recognized_extensions() -> PackedStringArray:
	return ["res", "tres"]
