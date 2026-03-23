# Rocket.Chat notifications GitHub action

This action sends a message to a Rocket.Chat server using a personal access token.
Read <https://docs.rocket.chat/docs/manage-personal-access-tokens> to obtain a new access token.

## Inputs

### `auth-token`

**Required** Personal access token for your Rocket.Chat server.

### `user-id`

**Required** User ID associated with the personal access token.

### `message`

**Required** The message you want to send.

### `server`

Your rocket.chat server. Default `"https://open.rocket.chat"`.

### `channel`

The channel you want to write to. Default `"GENERAL"`.

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
      uses: jadolg/rocketchat-notification-action@v3.0.0
      with:
        server: ${{ secrets.ROCKETCHAT_SERVER }}
        message: Wooops! Looks like something went wrong!
        auth-token: ${{ secrets.ROCKETCHAT_AUTH_TOKEN }}
        user-id: ${{ secrets.ROCKETCHAT_USER_ID }}
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
      uses: jadolg/rocketchat-notification-action@v3.0.0
      with:
        message: Woop! Woop! A new Pull Request has being created at ${{ github.event.pull_request.html_url }}
        auth-token: ${{ secrets.ROCKETCHAT_AUTH_TOKEN }}
        user-id: ${{ secrets.ROCKETCHAT_USER_ID }}
        channel: python_rocketchat_api
```
