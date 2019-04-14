--------------------------------------------------------------------------------------------------------------------------
name = " A Big Bag (大背包)"
author = "Roomcar"
version = "1.0.1"--DEV
description = "更新啦！请检查配置选项以免遇到问题！\n\nA 8x8 Big Bag.\n8x8的大背包。\nMake things fresh again.\n可选：让物品和食物恢复新鲜。\nGet full stack of things.\n可选：让物品自动堆叠至最大。\nGive items for building for free.\n可选：建造缺少物品时自动获取。\n可选：保命微光。"

api_version = 10
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_filter_tags = {"bigbag-roomcar's mod", "roomcar", "bigbag"}

forumthread = ""
icon_atlas = "bigbagicon.xml"
icon = "bigbagicon.tex"

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
		hover = "Get full stack when reopen the bag.",
		options = {
			{ description = "Off", data = false, },
			{ description = "On", data = true, },
		},
		default = false,
	},
	{
		name = "FRESH",
		label = "ReFresh (恢复新鲜)",
		hover = "ReFresh food and tools when reopen the bag.",
		options = {
			{ description = "Off", data = false, },
			{ description = "On", data = true, },
		},
		default = false,
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
			{ description = "Much Slower", data = 0.5, },
			{ description = "Slower", data = 0.75, },
			{ description = "No Change", data = 1, },
			{ description = "Faster", data = 1.25, },
			{ description = "Much Faster", data = 1.5, },
		},
		default = 0.75,
	},
	{
		name = "LIGHT",
		label = "Light (保命微光)",
		hover = "Let the bag give off light.",
		options = {
			{ description = "Off", data = false, },
			{ description = "On", data = true, },
		},
		default = false,
	},
	{
		name = "GIVE",
		label = "Give Items (获得物品)",
		hover = "Give Items If Can't Build Something.",
		options = {
			{ description = "Off", data = false, },
			{ description = "On", data = true, },
		},
		default = false,
	},
}



--------------------------------------------------------------------------------------------------------------------------
