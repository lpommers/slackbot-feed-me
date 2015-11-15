haveSomeWater = (robot) ->
  users = robot.brain.get('waterNotificationUsers')

  for user,userName of users
    robot.messageRoom "#{userName}", "Hey... I really think you ought to drink some aqua. Gots to stay hydrated"

module.exports = (robot) ->
  cronJob = require('cron').CronJob
  timeZone = 'Europe/Copenhagen'
  waterNotificationUsers = {}

  robot.brain.set('waterNotificationUsers', waterNotificationUsers)

  # once an hour, mon-fri between 10:30 and 15:30
  new cronJob('00 30 10-15 * * 1-5', haveSomeWater(robot), null, true, timeZone)

  # sign up
  robot.respond /water notification/i, (res) ->
    users = robot.brain.get('waterNotificationUsers')

    if not users[res.envelope.user.name]
      users[res.envelope.user.name] = res.envelope.user.name
      robot.brain.set('waterNotificationUsers', users)
      res.reply "you're gonna get water notifications now"
    else
      res.reply "you've already signed up to get dem water notifications"
