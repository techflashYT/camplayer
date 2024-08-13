#!/bin/bash

if [ `whoami` != root ]; then
 echo "Please run with sudo!"
 exit 1
fi

WORKDIR="$(dirname "$0")"
cd $WORKDIR

DESTPATH_APPDATA="/usr/local/share/camplayer/"
DESTPATH_BIN="/usr/local/bin/camplayer"
SYSTEMD_PATH="/lib/systemd/system/"

# ------ Install files to the correct location -------
# ----------------------------------------------------

# Copy application
echo "Copy appdate"
mkdir -p $DESTPATH_APPDATA
cp -v -R  * $DESTPATH_APPDATA
chmod 755 -R $DESTPATH_APPDATA

# Copy executable
echo "Copy executable"
cp -v ./bin/camplayer $DESTPATH_BIN
chmod 755 $DESTPATH_BIN

# Be sure normal users can't read our config file!
#chmod 600 $DESTPATH_APPDATA"settings.ini"

# --- Install the required distribution packages -----
# ----------------------------------------------------

echo "Installing required distribution packages"
apt-get update

if [ ! -e /usr/bin/ffprobe ]; then
    apt-get -y install ffmpeg
fi

if [ ! -e /usr/bin/vlc ]; then
    apt-get -y install vlc
fi

# --------- Install required python packages ---------
# ----------------------------------------------------

echo "Installing required python packages"
apt-get install -y python3-evdev
# ---------------- Systemd service -------------------
# ----------------------------------------------------

echo "Installing 'camplayer' as a systemd service"
cp -v camplayer.service $SYSTEMD_PATH
systemctl daemon-reload
systemctl disable camplayer.service


# --------------------- Done! ------------------------
# ----------------------------------------------------

echo "Done!"

