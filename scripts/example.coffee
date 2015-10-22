Yummly = require './yummly'

module.exports = (robot) ->
  @yummly = new Yummly robot

  robot.respond /feed me|feed me (.*)/i, (res) =>
    if res.match[1]
      if flag is "veggie"
        isVegetarian = true
      else
        isVegetarian = false
    else
      isVegetarian = false

    @yummly.giveMeARecipe(isVegetarian).then (recipe) ->
      res.send "COOK THIS!!! #{recipe.recipeName} \n http://www.yummly.com/recipe/#{recipe.id} \n #{recipe.smallImageUrls[0]}"
