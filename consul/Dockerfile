FROM debian:jessie

RUN apt-get update -y && apt-get install -y python-pip curl bsdmainutils
RUN pip install awscli
RUN curl -L https://releases.hashicorp.com/envconsul/0.6.2/envconsul_0.6.2_linux_amd64.tgz | tar xzf -

ENV AWS_DEFAULT_REGION eu-west-1

ADD init.sh /

ENTRYPOINT ["/init.sh"]
