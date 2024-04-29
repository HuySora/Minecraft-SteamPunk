ServerEvents.recipes(e => {
    e.remove({ id: 'create:crushing/scrap_cobbled_deepslate' })
    e.recipes.create.crushing(['minecraft:cobbled_deepslate', Item.of('minecraft:redstone').withChance(0.01)], 'minecraft:deepslate')
  })