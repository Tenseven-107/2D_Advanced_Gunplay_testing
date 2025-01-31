extends Node


# Signals
# - Player
signal drop_weapon(position, weapon)

# - Game camera effects
signal camera_shake(new_shake, shake_time, shake_limit)
signal camera_zoom(new_zoom, zoom_time, zoom_limit)
signal hitstop(time)
