Yummly = require './yummly'

module.exports = (robot) ->
  @yummly = new Yummly robot

  robot.respond /veggie/i, (res) =>
    @yummly.giveMeARecipe(true).then (recipe) ->
      res.reply "COOK THIS!!! #{recipe.recipeName} \n http://www.yummly.com/recipe/#{recipe.id} \n #{recipe.smallImageUrls[0]}"

  robot.respond /non-veggie/i, (res) =>
    @yummly.giveMeARecipe(false).then (recipe) ->
      res.reply "COOK THIS!!! #{recipe.recipeName} \n http://www.yummly.com/recipe/#{recipe.id} \n #{recipe.smallImageUrls[0]}"
