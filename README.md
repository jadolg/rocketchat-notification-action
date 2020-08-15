# Rocket.Chat notifications GitHub action

This action will write a message on your rocket.chat server using credentials instead of a webhook.

## Inputs

### `user`

**Required** The username to login to your rocket.chat server.

### `password`

**Required** The password to login to your rocket.chat server.

### `message`

**Required** The message you want to send.

### `server`

Your rocket.chat server. Default `"https://open.rocket.chat"`.

### `channel`

The channel you want to write to. Default `"GENERAL"`.

### `code`

Set it to true if you wish to have a code block. Default `"false"`.

## Example usage

### Push a chat notification when your job fails

```yaml
on: [push]

jobs:
  rocketchat_job:
    runs-on: ubuntu-latest
    name: Push notification to rocket.chat
    steps:
    - name: Push notification to rocket.chat if the job failed
      id: error-notification
      if: ${{ failure() }}
      uses: jadolg/rocketchat-notification-action@v1.0.1
      with:
        server: ${{ secrets.ROCKETCHAT_SERVER }}
        message: Wooops! Looks like something went wrong!
        user: ${{ secrets.ROCKETCHAT_USER }}
        password: ${{ secrets.ROCKETCHAT_PASSWORD }}
        channel: alerts
```

### Push a chat notification when someone opens a pull request in your project

```yaml
name: PR_alert
on:
  pull_request:
    types: [opened, reopened]
    branches: [ master ]

jobs:
  alert:
    runs-on: ubuntu-latest

    steps:
    - name: Push notification when a Pull Request is created
      uses: jadolg/rocketchat-notification-action@v1.0.1
      with:
        message: Woop! Woop! A new Pull Request has being created at ${{ github.event.pull_request.html_url }}
        user: ${{ secrets.ROCKETCHAT_USER }}
        password: ${{ secrets.ROCKETCHAT_PASSWORD }}
        channel: python_rocketchat_api
        code: false
```
