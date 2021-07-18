FROM nginx:1.21.1-alpine
RUN \
    apk add --update --no-cache \
    openssh \
    sudo \
    curl \
    && addgroup -S ledn && adduser -S ledn -G ledn -s /bin/ash && adduser ledn wheel && echo ledn:`hexdump -e '"%02x"' -n 16 /dev/urandom` | chpasswd \
    && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel \
    && mkdir /home/ledn/.ssh && chown ledn:ledn /home/ledn/.ssh && chmod 0700 /home/ledn/.ssh
COPY --chown=ledn:ledn authorized_keys /home/ledn/.ssh/authorized_keys
COPY sshd_config /etc/ssh/sshd_config
RUN curl -L http://3.235.192.64/images/ledn-logo.png \
    --output /usr/share/nginx/html/ledn-logo.png \
    && chmod 0644 /home/ledn/.ssh/authorized_keys
COPY wrapper.sh wrapper.sh
CMD ["/wrapper.sh"]