FROM debian:stable-slim

RUN apt-get update &&\
    apt-get install -y mariadb-client

COPY src/ /usr/local/bin
RUN chmod a+x /usr/local/bin/*.sh

CMD /usr/local/bin/db_user_init.sh
