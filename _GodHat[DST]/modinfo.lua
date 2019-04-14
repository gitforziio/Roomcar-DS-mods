--------------------------------------------------------------------------------------------------------------------------
name = "A GOD Hat (上帝头饰)"
author = "Roomcar"
version = "1.0.2"--DEV
description = "[Ver."..version.."]\nGOD's hat."

api_version = 10
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_filter_tags = {"godhat-roomcar's mod", "roomcar", "godhat"}

forumthread = ""
icon_atlas = "godhaticon.xml"
icon = "godhaticon.tex"

priority = 0

configuration_options = {
	{
		name = "LANG",
		label = "Language (语言)",
		hover = "Change display language.",
		options = {
			{ description = "English", data = 0, },
			{ description = "简体中文", data = 1, },
		},
		default = 0,
	},
	{
		name = "STACK",
		label = "Full Stack (自动堆满)",
		hover = "Get full stack when equip this item.",
		options = {
			{ description = "Off", data = false, },
			{ description = "On", data = true, },
		},
		default = true,
	},
	{
		name = "FRESH",
		label = "ReFresh (恢复新鲜)",
		hover = "ReFresh food and tools when equip this item.",
		options = {
			{ description = "Off", data = false, },
			{ description = "On", data = true, },
		},
		default = true,
	},
	{
		name = "RECIPE",
		label = "Recipe (耗材)",
		hover = "Recipe cost.",
		options = {
			{ description = "Very Cheap", data = 1, },
			{ description = "Cheap", data = 2, },
			{ description = "Normal", data = 3, },
			{ description = "Expensive", data = 4, },
			{ description = "More Expensive", data = 5, },
		},
		default = 3,
	},
	{
		name = "WALKSPEED",
		label = "Walk Speed (移速)",
		hover = "Walk speed while taking this bag.",
		options = {
			{ description = "No Change", data = 1.25, },
			{ description = "No Change", data = 1.5, },
			{ description = "Faster", data = 2, },
			{ description = "Much Faster", data = 2.5, },
		},
		default = 1.5,
	},
	{
		name = "LIGHT",
		label = "Light (照明)",
		hover = "Let this item give off light.",
		options = {
			{ description = "Off", data = false, },
			{ description = "On", data = true, },
		},
		default = true,
	},
	{
		name = "GIVE",
		label = "Give Items (获得物品)",
		hover = "Give Items If Can't Build Something.",
		options = {
			{ description = "Off", data = false, },
			{ description = "On", data = true, },
		},
		default = true,
	},
	{
		name = "PUNISH",
		label = "Punishment (卸下惩罚)",
		hover = "Get punished when unequiped.",
		options = {
			{ description = "Off", data = false, },
			{ description = "On", data = true, },
		},
		default = true,
	},
}

--------------------------------------------------------------------------------------------------------------------------
