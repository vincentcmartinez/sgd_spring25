class_name Watercan extends Tool
var usable = true
func use():
	if usable:
		charges -= 1
		if charges == 0:
			usable = false
		return true
	else:
		return false