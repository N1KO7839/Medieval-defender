extends RichTextLabel

var defaultText = "Highest score: "
func _process(delta: float) -> void:
	var text = str(defaultText, str(Global.highScore))
	self.text = (text)
