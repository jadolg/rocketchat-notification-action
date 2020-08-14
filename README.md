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
      uses: jadolg/rocketchat-notification-action@v1.0.0
      with:
        server: ${{ secrets.ROCKETCHAT_SERVER }}
        message: Wooops! Looks like something went wrong!
        user: ${{ secrets.ROCKETCHAT_USER }}
        password: ${{ secrets.ROCKETCHAT_PASSWORD }}
        channel: alerts
```
