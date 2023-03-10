FROM debian:latest

RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install -y \
    coreutils  \
    curl \
    jq \
    unzip

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip && ./aws/install

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
