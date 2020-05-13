FROM bats/bats:latest
RUN apk add --no-cache git
RUN apk add --no-cache fzf
ADD ./ /root/dotbare
RUN echo "PATH=$PATH:$HOME/dotbare" >> "$HOME"/.bashrc
WORKDIR /root/dotbare
RUN ./dotbare finit -u https://github.com/kazhala/dotfiles.git
ENTRYPOINT ["bats", "tests"]
