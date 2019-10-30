# We're using Alpine stable
FROM alpine:edge

#
# We have to uncomment Community repo for some packages
#
RUN sed -e 's;^#http\(.*\)/v3.9/community;http\1/v3.9/community;g' -i /etc/apk/repositories

# Installing Python
RUN apk add --no-cache --update \
        bash \
    build-base \
    bzip2-dev \
    curl \
    figlet \
    gcc \
    g++ \
    git \
    sudo \
    aria2 \
    util-linux \
    chromium \
    chromium-chromedriver \
    jpeg-dev \
    libffi-dev \
    libpq \
    libwebp-dev \
    libxml2 \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    musl \
    neofetch \
    openssl-dev \
    postgresql \
    postgresql-client \
    postgresql-dev \
    openssl \
    pv \
    jq \
    wget \
    python \
    python3 \
    python3-dev \
    readline-dev \
    sqlite \
    ffmpeg \
    sqlite-dev \
    sudo \
    zlib-dev

RUN pip3 install --upgrade pip setuptools

# Copy Python Requirements to /app

RUN  sed -e 's;^# \(%wheel.*NOPASSWD.*\);\1;g' -i /etc/sudoers
RUN adduser userbot --disabled-password --home /home/userbot
RUN adduser userbot wheel
USER userbot
RUN mkdir /home/userbot/userbot
RUN mkdir /home/userbot/bin
RUN git clone https://github.com/RacingDNaUnleashed/SpyderzzBot /home/userbot/userbot
WORKDIR /home/userbot/userbot
ADD ./requirements.txt /home/userbot/userbot/requirements.txt

#
# Copies session and config(if it exists)
#
COPY ./sample_config.env ./userbot.session* ./config.env* /home/userbot/userbot/

#
# Clone helper scripts
#
RUN curl -s https://raw.githubusercontent.com/yshalsager/megadown/master/megadown -o /home/userbot/bin/megadown && sudo chmod a+x /home/userbot/bin/megadown
RUN curl -s https://raw.githubusercontent.com/yshalsager/cmrudl.py/master/cmrudl.py -o /home/userbot/bin/cmrudl && sudo chmod a+x /home/userbot/bin/cmrudl
ENV PATH="/home/userbot/bin:$PATH"

#
# Install requirements
#
RUN sudo pip3 install -r requirements.txt
ADD . /home/userbot/userbot
RUN sudo chown -R userbot /home/userbot/userbot
RUN sudo chmod -R 777 /home/userbot/userbot
CMD ["python3","-m","userbot"]
