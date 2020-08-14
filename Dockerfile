FROM alpine:3.10
RUN wget https://github.com/aleph-engineering/rocketchat-notification/releases/download/1.4.1/rocketchat-notification -P /usr/bin/ && chmod +x /usr/bin/rocketchat-notification
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
