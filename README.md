# Long War Sample Mods

These mods serve as an example of how to perform various tasks within the Highlander modding framework. While they are all fully functional in-game, they are not heavily playtested or balanced.

## Installation

To install these mods from source, follow the same instructions as for building and enabling your own mods. Note that each of the mods is a separate Unreal package, so you will need to repeat the steps for each that you want to install.

Prebuilt versions will be available at a later date.

## Artifact Repair

**Artifact Repair** introduces some new Engineering capabilities, allowing the player to repair damaged alien artifacts: computers, power sources, surgeries, stasis tanks, and alien entertainments.

This mod demonstrates:

* Adding new items to the game.
* Using `HL_TItem.iReplacementItemId` to create new Engineering "recipes" to build existing items in new ways.

Note that these items all have a research prerequisite, so you won't see them in Engineering right away.

## Mass Production

**Mass Production** is a simple mod which makes certain items infinite after you've built enough of them. For example, once you've built 3 Laser Rifles, you now have all the Laser Rifles you want without building more. In addition, new soldiers will be automatically equipped with the highest tier weapons that you are mass producing, including blueshirts on base defenses.

This mod demonstrates:

* Overriding the `HL_GetItem` function results based on dynamic logic.
* Overriding the default primary and secondary weapons for new soldiers.
* Showing a Geoscape alert to the player.

Notes:

* Infinite items cannot be sold in the Gray Market, so once you've reached the mass production threshold on items, they will no longer appear there.
* The threshold is based on how many of each item have been obtained by any means, so capturing laser weapons from EXALT will contribute, as will using console commands.

### Known issues

* Infinite items can still be requested by the XCOM Council, giving the player free requests.