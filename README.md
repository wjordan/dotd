# DotD

Dev of the Day scripts for PagerDuty - HipChat integrations

## Usage

First, install the bundle:

```
bundle install
```

Next, add your credentials to a local `.env` file:

```
export PAGERDUTY_TOKEN=[pagerduty token]
export HIPCHAT_TOKEN=[hipchat token]
export GITHUB_TOKEN=[github token]
```

Finally, add a line to your crontab (`EDITOR=nano crontab -e`):
```
0,2,30,32 * * * * /bin/bash -c "/home/will/bin/update_dev_of_day > /dev/null"
```
