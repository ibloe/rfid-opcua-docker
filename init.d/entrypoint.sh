#!/bin/bash +e
# catch signals as PID 1 in a container

# SIGNAL-handler
term_handler() {

  echo "terminating ssh ..."
  /etc/init.d/ssh stop

  exit 143; # 128 + 15 -- SIGTERM
}

# on callback, stop all started processes in term_handler
trap 'kill ${!}; term_handler' INT KILL TERM QUIT TSTP STOP HUP

# run applications in the background
echo "starting ssh ..."
/etc/init.d/ssh start

echo "init gpio "
#sudo ./init.d/gpio.sh
echo "17" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio17/direction
echo "1" > /sys/class/gpio/gpio17/value

echo "starting opc-ua-server"
sudo /home/pi/opc-ua-server/rfid_opcua

# wait forever not to exit the container
while true
do
  tail -f /dev/null & wait ${!}
done

exit 0