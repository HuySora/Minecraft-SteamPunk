ServerEvents.recipes(e => {
    e.remove({ id: 'qualitycrops:sugar_cane_gold_from_sugar_cane_diamond'})
    e.shapeless('qualitycrops:sugar_diamond', 'qualitycrops:sugar_cane_diamond')
    e.remove({ id: 'qualitycrops:sugar_cane_iron_from_sugar_cane_gold'})
    e.shapeless('qualitycrops:sugar_gold', 'qualitycrops:sugar_cane_gold')
  })