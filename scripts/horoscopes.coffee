module.exports = (robot) ->
  cronJob = require('cron').CronJob
  timeZone = 'Europe/Copenhagen'
  horoscopeUsers = {}

  splitName = (nameFromSlack) ->
    nameFromSlack.split(' ')[0]

  getHoroscopes = ->
    users = robot.brain.get 'horoscopeUsers'

    robot.http('http://a.knrz.co/horoscope-api/current')
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse body
        horoscopes = {}

        data.forEach (eachSign) ->
          horoscopes[eachSign.sign] = eachSign.prediction

        for user of users
          # TODO: send entire user object and just their specific horoscope
          messageUser(user)

  messageUser = (user, horoscope) ->
    robot.messageRoom "#{user}", "hey #{horoscope.firstName}, your horoscope for the week is: *#{horoscopes[userData.horoscopeSign]}*"

  robot.respond /horoscope subscribe (.*)/i, (res) ->
    sign = res.match[1].toLowerCase()
    name = splitName(res.message.user.real_name)
    users = robot.brain.get('horoscopeUsers')

    # TODO: maybe turn this into a function
    if not users[res.message.user.name]
      users[res.message.user.name] =
        firstName: name,
        horoscopeSign: sign

    robot.brain.set 'horoscopeUsers', users

    getHoroscopes()

  robot.brain.set('horoscopeUsers', horoscopeUsers)

  new cronJob('* * * * * *', getHoroscopes, null, true, timeZone)

  # new cronJob('00 00 10 * * 1', getHoroscopes, null, true, timeZone)
