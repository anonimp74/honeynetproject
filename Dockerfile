FROM dinotools/dionaea:latest

# RUN apt-get update && apt-get install net-tools && apt-get install sqlite3

COPY config/dionaea/dionaea.cfg /opt/dionaea/etc/dionaea/dionaea.cfg
COPY config/dionaea/ihandlers /opt/dionaea/etc/dionaea/ihandlers-enabled/
COPY config/dionaea/services /opt/dionaea/etc/dionaea/services-enabled/

CMD /opt/dionaea/bin/dionaea -l info -L '*' -c /opt/dionaea/etc/dionaea/dionaea.cfg
