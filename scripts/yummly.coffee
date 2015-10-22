rp = require('request-promise')
Deferred = require('promise.coffee').Deferred

randomStartingPoint =  ->
  Math.floor(Math.random() * 5000)

class Yummly
  constructor: (@robot) ->
    @recipes = []
    @isVegetarian = false

  buildUrl: () ->
     apiString = 'http://api.yummly.com/v1/api/recipes?_app_id=09981ac4&_app_key=5f7f4b7a4eb4ebf0bcf4f3f0e5e47e2f'
     mainDishes = '&allowedCourse[]=course^course-' + encodeURIComponent('Main Dishes')
     salads = '&allowedCourse[]=course^course-' + encodeURIComponent('Salads')
     vegetarian  = '&allowedDiet[]=387^' + encodeURIComponent('Lacto-ovo vegetarian')
     startPoint = '&maxResult=90&start=' + randomStartingPoint()

     if @isVegetarian == true
       "#{apiString}#{mainDishes}#{salads}#{vegetarian}#{startPoint}"
     else
       "#{apiString}#{mainDishes}#{startPoint}"

  getRecipes: () ->
    yummlyUrl = @buildUrl(@isVegetarian)
    rp(yummlyUrl, {json: true})
    .then (response) =>
      @recipes = response.matches

  giveMeARecipe: (isVegetarian) ->
    deferred = new Deferred

    if @recipes.length == 0 or @isVegetarian != isVegetarian
      @isVegetarian = isVegetarian
      @getRecipes().then () =>
        deferred.resolve(@singleRecipe())
    else
      deferred.resolve(@singleRecipe())

    deferred.promise

  singleRecipe: ->
    randomIndex = Math.floor(Math.random() * (@recipes.length))
    @recipes.splice(randomIndex, 1)[0]

module.exports = Yummly
