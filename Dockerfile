FROM ubuntu:16.04

LABEL ubuntu.version="16.04" samtools.version="0.1.19" maintainer="Alice Minotto, @ Earlham Institute"

USER root

RUN apt-get -y update && apt-get -yy install samtools

WORKDIR /data/
