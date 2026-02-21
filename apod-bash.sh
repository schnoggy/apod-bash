#!/usr/bin/env bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

PID=$(pgrep -o gnome-session)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|tr '\0' '\n' |cut -d= -f2-)

nasa_api_key="GET_YOUR_OWN_API_KEY"
apod_api_url="https://api.nasa.gov/planetary/apod?api_key=$nasa_api_key"

apod_json=$(curl -s $apod_api_url)

apod_media_type=$(echo $apod_json | jq .media_type)

if [ "$apod_media_type" == "\"image\"" ];
then
        apod_hd_url=$(echo $apod_json | jq .hdurl)
        gsettings set org.gnome.desktop.background picture-uri $apod_hd_url
        gsettings set org.gnome.desktop.background picture-uri-dark $apod_hd_url

fi
