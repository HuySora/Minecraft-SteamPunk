ServerEvents.recipes(e => {
  e.recipes.create.crushing([Item.of('minecraft:netherite_scrap').withChance(0.01), Item.of('minecraft:obsidian').withChance(0.75)], 'minecraft:crying_obsidian')
})