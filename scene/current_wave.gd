extends RichTextLabel

var defaultText = "Current wave: "
func _process(delta: float) -> void:
	var text = str(defaultText, str(Global.currentWave))
	self.text = (text)
