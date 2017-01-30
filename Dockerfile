FROM debian:jessie

RUN apt-get update -y && apt-get install -y python-pip bsdmainutils
RUN pip install awscli

ENV AWS_DEFAULT_REGION eu-west-1

ADD init.sh /

ENTRYPOINT ["/init.sh"]
