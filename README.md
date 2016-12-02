# lita-heroku-keepalive

A gem that keeps the Lita Heroku free web dyno alive.
Note that a [free Heroku dyno can only run for 18 hours/day](https://blog.heroku.com/archives/2015/5/7/new-dyno-types-public-beta#hobby-and-free-dynos), so it will be required to sleep for at least 6 hours. Accessing your Lita during a sleep period will wake it, but it will return to sleep after 30 minutes.

## Installation

Add lita-heroku-keepalive to your Lita instance's Gemfile:

``` ruby
gem "lita-heroku-keepalive"
```

And then execute:

    $ bundle

install it yourself as:
	
    $ gem install lita-heroku-keepalive

## Configuration


lita-heroku-keepalive is configured by four environment variables:

* `LITA_HEROKU_KEEPALIVE_URL` - required, the complete URL to keepalive, including a trailing slash.
* `LITA_HEROKU_WAKEUP_TIME` - optional,  the time of day (HH:MM) when lita should wake up.  Default: 6:00 (6 am)
* `LITA_HEROKU_SLEEP_TIME` - optional, the time of day (HH:MM) when lita should go to sleep. Default: 22:00 (10 pm)
* `LITA_HEROKU_KEEPALIVE_INTERVAL` - the interval in which to keepalive, in minutes. Default: 5

You *must* set `LITA_HEROKU_KEEPALIVE_URL` and it *must* include a trailing slash – otherwise the script won't run. 
You can find out the value for this by running `heroku apps:info`. Copy the `Web URL` and run:

```
heroku config:set LITA_HEROKU_KEEPALIVE_URL=PASTE_WEB_URL_HERE
```

If you want to trust a shell snippet from the Internet, here's a one-liner:

```
heroku config:set LITA_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s | grep web-url | cut -d= -f2)
```

`LITA_HEROKU_WAKEUP_TIME` and `LITA_HEROKU_SLEEP_TIME` define the waking hours - between these times the keepalive will ping your Heroku app.  Outside of those times, the ping will be suppressed, allowing the dyno to shut down. These times are based on the timezone of your Heroku application which defaults to UTC.  You can change this with:

```
heroku config:add TZ="America/New_York"
```


## Usage

TODO: Describe the plugin's features and how to use them.


## Waking Lita Up

This gem will keep the dyno alive once it is awake, but something needs to wake it up. You can use the [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler) to wake the dyno up. Add the scheduler addon by running:

```
heroku addons:create scheduler:standard
```
The scheduler must be manually configured from the web interface, so run `heroku addons:open scheduler` and configure it to run `curl ${LITA_HEROKU_KEEPALIVE_URL}heroku/keepalive` at the time configured for `LITA_HEROKU_WAKEUP_TIME`.

![Heroku Scheduler Screenshot](https://cloud.githubusercontent.com/assets/173/9414275/2e4b67ea-4805-11e5-80d0-d6b26ead50ef.png)

Note that the Scheduler's time is in UTC. If you changed your application's timezone with `TZ`, you'll need to convert that time to UTC for the wakup job. For example, if `LITA_HEROKU_WAKEUP_TIME` is set to `06:00` and `TZ` is set to `America/New_York`, you'll need to set the Scheduler to run at 10:00 AM UTC.
