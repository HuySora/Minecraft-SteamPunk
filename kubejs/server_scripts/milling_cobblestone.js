ServerEvents.recipes(e => {
    e.remove({ id: 'create:milling/cobblestone' })
    e.recipes.create.milling(['minecraft:gravel', Item.of('minecraft:coal').withChance(0.01)], 'minecraft:cobblestone')
  })