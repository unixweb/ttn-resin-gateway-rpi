#! /bin/bash

# Configure the global and local configuration files via the environment

echo "******************"
echo "*** Configuration:"
echo "******************"

if [[ $GW_REGION == "" ]]; then
    echo "ERROR: GW_REGION required"
    while true; do sleep 10; done
fi
echo GW_REGION: $GW_REGION

if [[ $GW_DESCRIPTION == "" ]]; then
    echo "ERROR: GW_DESCRIPTION required"
    while true; do sleep 10; done # don't exit in resin
	exit 1
fi

if [[ $GW_CONTACT_EMAIL == "" ]]; then
    echo "ERROR: GW_CONTACT_EMAIL required"
    while true; do sleep 10; done # don't exit in resin
	exit 1
fi

if [[ $GW_REF_LATITUDE == "" ]]; then
    echo "ERROR: GW_REF_LATITUDE required"
    while true; do sleep 10; done # don't exit in resin
	exit 1
fi

if [[ $GW_REF_LONGITUDE == "" ]]; then
    echo "ERROR: GW_REF_LONGITUDE required"
    while true; do sleep 10; done # don't exit in resin
	exit 1
fi

if [[ $GW_REF_ALTITUDE == "" ]]; then
    echo "ERROR: GW_REF_ALTITUDE required"
    while true; do sleep 10; done # don't exit in resin
    exit 1
fi

echo "******************"
echo ""

# load the region-appropriate global conf

if curl -sS --fail https://raw.githubusercontent.com/rayozzie/ttn-gateway-conf/master/$GW_REGION-global_conf.json --output ./global_conf.json
then
	echo Successfully loaded $GW_REGION-global_conf.json from TTN repo
else
	echo "******************"
    echo "ERROR: GW_REGION not found"
	echo "******************"
    while true; do sleep 10; done # don't exit in resin
    exit 1
fi

# set up environmental defaults for local.conf

if [[ $GW_GPS == "" ]]; then GW_GPS="true"; fi
if [[ $GW_BEACON == "" ]]; then GW_BEACON="false"; fi
if [[ $GW_MONITOR == "" ]]; then GW_MONITOR="false"; fi
if [[ $GW_UPSTREAM == "" ]]; then GW_UPSTREAM="true"; fi
if [[ $GW_DOWNSTREAM == "" ]]; then GW_DOWNSTREAM="true"; fi
if [[ $GW_GHOSTSTREAM == "" ]]; then GW_GHOSTSTREAM="false"; fi
if [[ $GW_RADIOSTREAM == "" ]]; then GW_RADIOSTREAM="true"; fi
if [[ $GW_STATUSSTREAM == "" ]]; then GW_STATUSSTREAM="true"; fi

if [[ $GW_SERVER_ADDRESS == "" ]]; then GW_SERVER_ADDRESS="127.0.0.1"; fi
if [[ $GW_SERV_PORT_UP == "" ]]; then GW_SERV_PORT_UP="1600"; fi
if [[ $GW_SERV_PORT_DOWN == "" ]]; then GW_SERV_PORT_DOWN="1601"; fi

if [[ $GW_KEEPALIVE_INTERVAL == "" ]]; then GW_KEEPALIVE_INTERVAL="10"; fi
if [[ $GW_STAT_INTERVAL == "" ]]; then GW_STAT_INTERVAL="30"; fi
if [[ $GW_PUSH_TIMEOUT_MS == "" ]]; then GW_PUSH_TIMEOUT_MS="100"; fi

if [[ $GW_FORWARD_CRC_VALID == "" ]]; then GW_FORWARD_CRC_VALID="true"; fi
if [[ $GW_FORWARD_CRC_ERROR == "" ]]; then GW_FORWARD_CRC_ERROR="false"; fi
if [[ $GW_FORWARD_CRC_DISABLED == "" ]]; then GW_FORWARD_CRC_DISABLED="false"; fi

if [[ $GW_GPS_TTY_PATH == "" ]]; then GW_GPS_TTY_PATH="/dev/ttyAMA0"; fi
if [[ $GW_FAKE_GPS == "" ]]; then GW_FAKE_GPS="true"; fi

if [[ $GW_GHOST_ADDRESS == "" ]]; then GW_GHOST_ADDRESS="127.0.0.1"; fi
if [[ $GW_GHOST_PORT == "" ]]; then GW_GHOST_PORT="1918"; fi

if [[ $GW_MONITOR_ADDRESS == "" ]]; then GW_MONITOR_ADDRESS="127.0.0.1"; fi
if [[ $GW_MONITOR_PORT == "" ]]; then GW_MONITOR_PORT="2008"; fi

if [[ $GW_SSH_PATH == "" ]]; then GW_SSH_PATH="/usr/bin/ssh"; fi
if [[ $GW_SSH_PORT == "" ]]; then GW_SSH_PORT="22"; fi

if [[ $GW_HTTP_PORT == "" ]]; then GW_HTTP_PORT="80"; fi

if [[ $GW_NGROK_PATH == "" ]]; then GW_NGROK_PATH="/usr/bin/ngrok"; fi

if [[ $GW_SYSTEM_CALLS == "" ]]; then GW_SYSTEM_CALLS="[\"df -m\",\"free -h\",\"uptime\",\"who -a\",\"uname -a\"]"; fi

if [[ $GW_PLATFORM == "" ]]; then GW_PLATFORM="*"; fi

# create local.conf

echo -e "{\n\
\t\"gateway_conf\": {\n\
\t\t\"ref_latitude\": $GW_REF_LATITUDE,\n\
\t\t\"ref_longitude\": $GW_REF_LONGITUDE,\n\
\t\t\"ref_altitude\": $GW_REF_ALTITUDE,\n\
\t\t\"contact_email\": \"$GW_CONTACT_EMAIL\",\n\
\t\t\"description\": \"$GW_DESCRIPTION\", \n\
\t\t\"gps\": $GW_GPS,\n\
\t\t\"beacon\": $GW_BEACON,\n\
\t\t\"monitor\": $GW_MONITOR,\n\
\t\t\"upstream\": $GW_UPSTREAM,\n\
\t\t\"downstream\": $GW_DOWNSTREAM,\n\
\t\t\"ghoststream\": $GW_GHOSTSTREAM,\n\
\t\t\"radiostream\": $GW_RADIOSTREAM,\n\
\t\t\"statusstream\": $GW_STATUSSTREAM,\n\
\t\t\"server_address\": $GW_SERVER_ADDRESS,\n\
\t\t\"serv_port_up\": $GW_SERV_PORT_UP,\n\
\t\t\"serv_port_down\": $GW_SERV_PORT_DOWN,\n\
\t\t\"keepalive_interval\": $GW_KEEPALIVE_INTERVAL,\n\
\t\t\"stat_interval\": $GW_STAT_INTERVAL,\n\
\t\t\"push_timeout_ms\": $GW_PUSH_TIMEOUT_MS,\n\
\t\t\"forward_crc_valid\": $GW_FORWARD_CRC_VALID,\n\
\t\t\"forward_crc_error\": $GW_FORWARD_CRC_ERROR,\n\
\t\t\"forward_crc_disabled\": $GW_FORWARD_CRC_DISABLED,\n\
\t\t\"gps_tty_path\": $GW_GPS_TTY_PATH,\n\
\t\t\"fake_gps\": $GW_FAKE_GPS,\n\
\t\t\"ghost_address\": $GW_GHOST_ADDRESS,\n\
\t\t\"ghost_port\": $GW_GHOST_PORT,\n\
\t\t\"monitor_address\": $GW_MONITOR_ADDRESS,\n\
\t\t\"monitor_port\": $GW_MONITOR_PORT,\n\
\t\t\"ssh_path\": $GW_SSH_PATH,\n\
\t\t\"ssh_port\": $GW_SSH_PORT,\n\
\t\t\"http_port\": $GW_HTTP_PORT,\n\
\t\t\"ngrok_path\": $GW_NGROK_PATH,\n\
\t\t\"system_calls\": $GW_SYSTEM_CALLS,\n\
\t\t\"platform\": $GW_PLATFORM,\n\
\t\t\"gateway_ID\": \"0000000000000000\"\n\
\t}\n\
}" >./local_conf.json

# Reset gateway ID based on MAC

echo "******************"
../packet_forwarder/reset_pkt_fwd.sh start ./local_conf.json
echo "******************"
echo ""

# Test the connection, wait if needed.
while [[ $(ping -c1 google.com 2>&1 | grep " 0% packet loss") == "" ]]; do
  echo "[TTN Gateway]: Waiting for internet connection..."
  sleep 30
  done

# Fire up the forwarder.  
while true
  do
    echo "[TTN Gateway]: Starting packet forwarder..."
    ./poly_pkt_fwd
	echo "******************"
    echo "*** [TTN Gateway]: EXIT (retrying in 15s)"
	echo "******************"
    sleep 15
  done
