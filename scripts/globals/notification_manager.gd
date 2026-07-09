extends Node

var notification_ui: CanvasLayer = null

func register(ui: CanvasLayer):
	notification_ui = ui

func show(message: String, duration: float = 2.0):
	if notification_ui:
		notification_ui.show_notification(message, duration)
	else:
		push_warning("Notification UI is not registered.")
