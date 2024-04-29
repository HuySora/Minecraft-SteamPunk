ServerEvents.recipes(e => {
    e.remove({ id: 'minecraft:deepslate'})
    e.recipes.create.compacting('minecraft:deepslate', [Fluid.lava(1000),'16x #forge:sand']).superheated()
  })