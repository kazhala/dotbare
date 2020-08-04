FROM bats/bats:latest
RUN apk add --no-cache git
RUN apk add --no-cache fzf
ENV COLUMNS=80
ADD ./ /root/dotbare
RUN echo "source /root/dotbare/dotbare.plugin.bash" >> "$HOME"/.bashrc
WORKDIR /root/dotbare
ARG MIGRATE='url'
RUN [ "$MIGRATE" = 'url' ] && ./dotbare finit -u https://github.com/kazhala/dotfiles.git || :
RUN [ "$MIGRATE" = 'bare' ] && ./dotbare finit -y || :
ENTRYPOINT ["bats", "tests"]
