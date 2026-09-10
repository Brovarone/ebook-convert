# Usiamo l'ultima versione stabile a lungo termine (LTS) di Ubuntu
FROM ubuntu:24.04

# creates a docker image that will convert an ebook from one format to another (guessed by file extensions of input)
# see: https://manual.calibre-ebook.com/generated/en/ebook-convert.html

# Evita blocchi interattivi durante l'installazione dei pacchetti
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /target
VOLUME ["/target"]
WORKDIR /target

# Installiamo le dipendenze minime moderne necessarie per far girare Calibre (incluse le nuove Qt6)
RUN apt-get update && apt-get install --no-install-recommends -y \
        ca-certificates \
        libgl1 \
        libglx0 \
        libegl1 \
        libopengl0 \
        libxcb-cursor0 \
        libxcomposite1 \
        libxrandr2 \
        libxkbcommon0 \
        libdbus-1-3 \
        libfontconfig1 \
        libnss3 \
        libasound2t64 \
        python3 \
        wget \
        xdg-utils \
        xz-utils \
    && apt-get clean \
    && rm -rf /var/tmp/* /tmp/* /var/lib/apt/lists/*

# Scarica ed esegue l'installatore ufficiale all'ULTIMA versione disponibile di Calibre
RUN wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin
