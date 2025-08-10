FROM ubuntu:latest

# Set up environment
RUN apt update -y && apt upgrade -y && apt install locales -y \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install dependencies
RUN apt install ssh wget unzip -y

# Install ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip \
    && unzip ngrok.zip \
    && mv ngrok /usr/local/bin/ngrok \
    && rm ngrok.zip

# SSH config
RUN mkdir /var/run/sshd \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "root:kai" | chpasswd

# Entrypoint script with token already set
RUN echo '#!/bin/bash' > /kai.sh \
    && echo "ngrok config add-authtoken 2fPKIh6j4X4jawawHgelMvTl4jX_5MYSzicBfGviZMQrN8fpC" >> /kai.sh \
    && echo "ngrok tcp 22 &" >> /kai.sh \
    && echo "/usr/sbin/sshd -D" >> /kai.sh \
    && chmod +x /kai.sh

# Ports
EXPOSE 22 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

CMD ["/kai.sh"]
