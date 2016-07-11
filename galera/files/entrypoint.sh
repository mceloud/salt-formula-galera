{%- from "galera/map.jinja" import server with context -%}
#!/bin/bash -e

cat /srv/salt/pillar/galera-server.sls | envsubst > /tmp/galera-server.sls
mv /tmp/galera-server.sls /srv/salt/pillar/galera-server.sls

salt-call --local --retcode-passthrough state.highstate

{% for service in server.services %}
service {{ service }} stop || true
{% endfor %}

/usr/sbin/mysqld --basedir=/usr/ --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql --pid-file=/var/lib/mysql/mysqld.pid --socket=/var/run/mysqld/mysqld.sock --port=3306

{#-
vim: syntax=jinja
-#}