# Dockerfile to create environment under which the artifact survey and call analyses can run
# Build via: docker build -t artifact-survey:latest -f Dockerfile .

FROM ubuntu:focal

ARG USER=artifact-evaluator

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install git r-base libssl-dev libcurl4-openssl-dev libfontconfig-dev libgtk2.0-dev xvfb xauth xfonts-base libxt-dev

WORKDIR /home/$USER

COPY . /home/$USER/artifact-survey

CMD /bin/bash