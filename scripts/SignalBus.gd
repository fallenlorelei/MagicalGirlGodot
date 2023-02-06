extends Node

#Stats
#signal hp_max_changed(new_hp_max)
#signal hp_changed(new_hp, max_hp)
#signal damage_indicator(type, amount)
signal died

#UI
signal mouseover(TF)
signal mouseOverLock(TF)
signal shake_hp_bar()
signal update_player_hp_bar(current_hp, max_hp)

#Skills
signal start_cooldown
signal begin_shadowmeld(length, cursorDirection)
