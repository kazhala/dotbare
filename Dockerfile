FROM bash:latest
RUN apk add --no-cache git
RUN apk add --no-cache vim
RUN apk add --no-cache fzf
ADD ./ /root/dotbare
RUN echo "source /root/dotbare/dotbare.plugin.bash" >> "$HOME"/.bashrc
WORKDIR /root
ENTRYPOINT ["bash"]
