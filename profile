export RDECK_JVM="$RDECK_JVM \
  -Drundeck.jetty.connector.forwarded=true \
  -Dserver.http.host=0.0.0.0 \
  -Dserver.hostname=$(hostname) \
  -Dserver.http.port=${SERVER_PORT:-4440}"
