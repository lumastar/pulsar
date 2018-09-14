#!/bin/bash

# Check the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "jackd2 install error: must be run as root, will now exit"
   exit 1
fi

function jackd2_install()
{
	apt-get update
	apt-get install -y git libasound2-dev libsndfile1-dev libreadline-dev libreadline6-dev libtinfo-dev
	git clone https://github.com/jackaudio/jack2.git --depth 1
	cd jack2
	./waf configure
	# Use the line below if jack is already installed
	#./waf configure --prefix /usr
	./waf build
	./waf install
	ldconfig
	sh -c "echo @audio - memlock 256000 >> /etc/security/limits.conf"
	sh -c "echo @audio - rtprio 75 >> /etc/security/limits.conf"
	cd ..
	rm -rf jack2
}

function aubio_install()
{
	apt-get update
	apt-get install -y git
	git clone https://github.com/aubio/aubio
	cd aubio/
	./scripts/get_waf.sh
	./waf configure --enable-jack
	./waf build
	./waf install
	cp -a aubio/build/src/* /usr/lib/
	cd ..
	rm -rf aubio
}

function a2jmidid_install()
{
	git clone http://repo.or.cz/a2jmidid.git
	cd a2jmidid
	./waf configure --disable-dbus
	./waf
	./waf install
	cd ..
	rm -rf a2jmidid
}

function jackmeter_install()
{
	wget https://www.aelius.com/njh/jackmeter/jackmeter-0.4.tar.gz
	tar -xvzf jackmeter-0.4.tar.gz
	cd jackmeter-0.4/
	./configure
	make
	make install
	cd ..
	rm -rf jackmeter-0.4
	rm jackmeter-0.4.tar.gz
}

function pulsar_install
{
	chmod +x pulsar
	cp pulsar /etc/init.d/
	update-rc.d pulsar defaults
}

jackd2_install
aubio_install
a2jmidid_install
jackmeter_install
