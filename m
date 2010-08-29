From: "Stamper, Brian P. (ARC-D)[Logyx LLC]" <brian.p.stamper@nasa.gov>
Subject: Re: oblem with lvm and multipath on fedora 13
Date: Sun, 29 Aug 2010 14:08:18 -0500
Message-ID: <12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DE@NDJSSCC07.ndc.nasa.gov>
References: <20100827182634.GB31618@us.ibm.com>
	<C89D80D7.10732%brian.p.stamper@nasa.gov>
	<20100828174751.GA31397@us.ibm.com>
	<12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DB@NDJSSCC07.ndc.nasa.gov>,
	<20100829183943.GA22562@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100829183943.GA22562@us.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

>So run "kpartx -a /dev/mapper/<yourmultipathdevice>" on each multipath
>device and then run LVM scan.

>If LVM still uses paths and complains about duplicate PVs, then you may
>need create a right filter in /etc/lvm/lvm.conf to use intended devices.
>I hope this is not necessary.

This works and is a huge improvement.  At least I can get my devices back into multipath manually.  Thanks so much for this.  I still need to get to the bottom of why these specific volumes are getting grabbed before multipath can get them, but this is a big step.

>Did you enable multipathd service (I thought it should call kpartx or maybe a udev rule)?

Yes, it's chkconfig'ed on, and I bumped forward its start order to start up prior to lvm2-monitor, thinking lvm2-monitor (which does vgscan) might be part of the problem.

>> [root@testfs foo]# find . -print | grep -i multi
>> ./lib/modules/2.6.33.8-149.fc13.x86_64/kernel/drivers/md/dm-multipath.ko
>The dm-multipath.ko kernel module is present. It needs multipath command
>calling from an initrd script (/init ???)

I'm not positive that I'm sure what you're asking.  Do you mean the init.d script I reference above, or is there some other configuration change to call mulitpath from initrd?

I feel much better knowing that I can get back to a proper configuration manually, but any ideas about why this is happening on bootup?  FYI, I played around with filtering in lvm.conf in my first night of troubleshooting and tried filtering out all /dev/sd.* drives other than /dev/sda, but it seems like dracut was ignoring the lvm filters, despite the lvm.conf.  With the filter in place a pvscan would find no duplicates (and no sd.* devices) but on reboot dracut would find them all and report the dupes.

Thanks for your help so far Malahal.

-Brian
