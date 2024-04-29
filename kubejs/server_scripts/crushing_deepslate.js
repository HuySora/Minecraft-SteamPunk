ServerEvents.recipes(e => {
    e.remove({ id: 'create:crushing/scrap_cobblestone_small' })
    e.recipes.create.crushing(['minecraft:cobblestone', Item.of('minecraft:lapis_lazuli').withChance(0.01)], 'minecraft:cobbled_deepslate')
  })