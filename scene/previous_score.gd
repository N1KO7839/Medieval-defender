extends RichTextLabel

var defaultText = "Previous score: "
func _process(delta: float) -> void:
	var text = str(defaultText, str(Global.previousScore))
	self.text = (text)
