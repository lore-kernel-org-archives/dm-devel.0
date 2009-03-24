From: Thomas Witzel <witzel.thomas@gmail.com>
Subject: Re: configure MD3000 episode 2
Date: Tue, 24 Mar 2009 10:29:13 -0400
Message-ID: <d1392840903240729h5a37f939u1cdb13a4608748d7@mail.gmail.com>
References: <d1392840903201754g119199d1u5b3863ba3a96abad@mail.gmail.com>
	<20090323143127.GA12731@mars.virtualiron.com>
	<d1392840903230844pe310cceya9160bcbe274b735@mail.gmail.com>
	<d1392840903231405p7b99846g65882690df77e96b@mail.gmail.com>
	<20090324140654.GA1606@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090324140654.GA1606@mars.virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Okay, I'm looking for a man page:
man -k hotplug finds nothing

I'm looking for the file you mentioned:
ls /sbin/hotplug
ls: cannot access /sbin/hotplug: No such file or directory

I'm looking for a package to install related to hotplug:

apt-cache search hotplug
libxi-dev - X11 Input extension library (development headers)
libxi6 - X11 Input extension library
libxi6-dbg - X11 Input extension library (debug package)
fxload - Firmware download to EZ-USB devices
libaws-dev - Ada Web Server development files
atmel-firmware - Firmware for Atmel at76c50x wireless networking chips.

Seems like there is NOTHING on ubuntu even remotely called hotplug,
except /proc/sys/kernel/hotplug
which is not a configuration file.

What distribution are you using ?

Thomas
