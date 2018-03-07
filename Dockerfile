FROM resin/raspberrypi3-node

#ENV INITSYSTEM on

RUN apt-get update \
    && apt-get install -y dnsmasq wireless-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

RUN curl https://api.github.com/repos/resin-io/resin-wifi-connect/releases/latest -s \
    | grep -hoP 'browser_download_url": "\K.*armv7hf\.tar\.gz' \
    | xargs -n1 curl -Ls \
    | tar -xvz -C /usr/src/app/

RUN echo dhcp-range=interface:wlan0,192.168.42.2,192.168.42.254,255.255.255.0,12h >> /etc/dnsmasq.conf

COPY scripts/start.sh .

CMD ["bash","/usr/src/app/start.sh"]


