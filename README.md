# [Amx Mod X] EntityRemover
Make it possible to remove predefined map entities at map starting.

# Plugin description:
The concept of this plugin is make it possible to remove entities from any or specific maps.
Got it, but, what does an entity mean ? Entities are objects which follow some behavior in-game, just like doors, breakable objects, ambient sounds and even the players.

# How to use:
This plugin works over external settings, that means that it'll load the entities list from a file defined by you. By default, I defined this file as "cstrike_entity_remover.ini" and it must to be inside "configs" folder.

For entities' removal in all maps, inside "AllMaps", define your entity list. Example:

AllMaps
{
    func_buyzone
}


For entities' removal in spefific maps, specific the map name and define the entity list. Example:

cs_assault
{
    func_door
    func_door_rotating
}

de_dust2
{
    func_breakable
}
