#!/bin/sh

echo "Configuring Tor browser"

cd /browser-cfg
if [ -f "prefs.js" ]
then
	echo "Copying User Preference overrides"
	cat prefs.js >> /app/Browser/TorBrowser/Data/Browser/profile.default/prefs.js
fi

echo "Starting Tor browser"

cd /app
./Browser/start-tor-browser --verbose --log /tmp/start-tor-browser.log

echo "Tor browser exited"
