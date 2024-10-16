extends RichTextLabel

var defaultText = "Current score: "
func _process(delta: float) -> void:
	var text = str(defaultText, str(Global.currentScore))
	self.text = (text)
