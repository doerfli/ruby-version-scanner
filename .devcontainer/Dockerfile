FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-3-bullseye

COPY library-scripts/docker-debian.sh /tmp/library-scripts/
ENV DOCKER_BUILDKIT=1
RUN apt-get update && bash /tmp/library-scripts/docker-debian.sh
ENTRYPOINT ["/usr/local/share/docker-init.sh"]
CMD ["sleep", "infinity"]
