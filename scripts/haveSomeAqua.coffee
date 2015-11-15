module.exports = (robot) ->
  cronJob = require('cron').CronJob
  timeZone = 'Europe/Copenhagen'
  waterNotificationUsers = {}

  robot.brain.set('waterNotificationUsers', waterNotificationUsers)

  # once an hour, mon-fri between 10:30 and 15:30
  new cronJob('00 30 10-15 * * 1-5', haveSomeWater(robot), null, true, timeZone)
