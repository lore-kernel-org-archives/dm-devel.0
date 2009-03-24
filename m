From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: configure MD3000 episode 2
Date: Tue, 24 Mar 2009 10:47:27 -0400
Message-ID: <20090324144727.GA1878@mars.virtualiron.com>
References: <d1392840903201754g119199d1u5b3863ba3a96abad@mail.gmail.com>
	<20090323143127.GA12731@mars.virtualiron.com>
	<d1392840903230844pe310cceya9160bcbe274b735@mail.gmail.com>
	<d1392840903231405p7b99846g65882690df77e96b@mail.gmail.com>
	<20090324140654.GA1606@mars.virtualiron.com>
	<d1392840903240729h5a37f939u1cdb13a4608748d7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d1392840903240729h5a37f939u1cdb13a4608748d7@mail.gmail.com>
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

On Tue, Mar 24, 2009 at 10:29:13AM -0400, Thomas Witzel wrote:
> Okay, I'm looking for a man page:
> man -k hotplug finds nothing
> 
> I'm looking for the file you mentioned:
> ls /sbin/hotplug
> ls: cannot access /sbin/hotplug: No such file or directory
> 
> I'm looking for a package to install related to hotplug:
> 
> apt-cache search hotplug
> libxi-dev - X11 Input extension library (development headers)
> libxi6 - X11 Input extension library
> libxi6-dbg - X11 Input extension library (debug package)
> fxload - Firmware download to EZ-USB devices
> libaws-dev - Ada Web Server development files
> atmel-firmware - Firmware for Atmel at76c50x wireless networking chips.
> 
> Seems like there is NOTHING on ubuntu even remotely called hotplug,
> except /proc/sys/kernel/hotplug

I am looking at my Debian box, and it looks as if the initrd
/scripts/init-premount/udev does start the udev daemon. And the
/etc/udev/rules.d has many rules.

Sorry for leading you on this chase.

> which is not a configuration file.

When you create the initrd, does the initrd have your multipathd and
its rules?


> 
> What distribution are you using ?

RHEL, FC, Ubuntu, Debian and SLES. But I haven't dug in the initrd of Debian/Ubuntu
so I can't much help there :-(

> 
> Thomas
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
