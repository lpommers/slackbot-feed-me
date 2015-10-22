rp = require('request-promise')
Deferred = require('promise.coffee').Deferred

recipeIndexArr = (num) ->
  recipeIndexes = []
  for x in [0...num] by 1
    recipeIndexes.push(x)
  recipeIndexes

randomStartingPoint =  ->
  Math.floor(Math.random() * 5000)

class Yummly
  constructor: (@robot) ->
    @counter = 1
    @recipeIndexes = recipeIndexArr(90)
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
       "#{apiString}#{mainDishes}#{salads}#{startPoint}"

  getRecipes: () ->
    yummlyUrl = @buildUrl(@isVegetarian)
    rp(yummlyUrl, {json: true})
    .then (response) =>
      @recipes = response.matches

  giveMeARecipe: (isVegetarian) ->
    deferred = new Deferred

    if @recipes.length == 0 or @isVegetarian != isVegetarian
      @isVegetarian = isVegetarian
      @counter = 1
      @getRecipes(isVegetarian).then () =>
        deferred.resolve(@singleRecipe())

    else if @counter is 88
      @counter = 1
      @recipeIndexes = recipeIndexArr(90)
      @getRecipes(isVegetarian).then () =>
        deferred.resolve(@singleRecipe())
    else
      @counter += 1
      deferred.resolve(@singleRecipe())

    deferred.promise

  singleRecipe: ->
    @recipes[@recipeIndexes.splice(Math.random()*@recipeIndexes.length, 1)[0]]

module.exports = Yummly
