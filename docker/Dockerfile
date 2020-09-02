FROM debian:buster

RUN apt-get update ; apt-get install -y --no-install-suggests packaging-dev

ADD ./entrypoint.sh /bin/entrypoint.sh

WORKDIR /code

ENTRYPOINT ["/bin/entrypoint.sh"]
