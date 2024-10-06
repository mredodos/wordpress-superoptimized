#!/bin/bash

# Avvio di PHP-FPM
echo "Starting PHP-FPM..."
service php8.2-fpm start

# Controllo se PHP-FPM è in esecuzione
if ! pgrep php-fpm > /dev/null; then
  echo "PHP-FPM failed to start!"
  exit 1
fi

# Avvio di Nginx
echo "Starting Nginx..."
service nginx start

# Controllo se Nginx è in esecuzione
if ! pgrep nginx > /dev/null; then
  echo "Nginx failed to start!"
  exit 1
fi

# Avvio di Varnish
echo "Starting Varnish..."
varnishd -f /etc/varnish/default.vcl -a :6081 -T localhost:6082 -s malloc,256m

# Controllo se Varnish è in esecuzione
if ! pgrep varnishd > /dev/null; then
  echo "Varnish failed to start!"
  exit 1
fi

# Log delle informazioni di avvio
echo "All services started successfully."

# Mantieni il container in esecuzione e logga l'output
tail -f /var/log/nginx/access.log /var/log/nginx/error.log /var/log/varnish/varnish.log