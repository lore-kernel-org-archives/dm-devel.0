From: David Cramblett <david@functionalchaos.net>
Subject: device mapper not finding all devices
Date: Sun, 17 Jul 2011 12:03:21 -0700
Message-ID: <CA+cRLpLs7CL4VeSw9YNGdTDOUG8mz=TpUuzyP=sWXpLiKywA+A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I apologize if this is the wrong place to be seeking assistance.  The
OS specific support lists didn't seem to know anything about this
issue.

I updated my system and after reboot the logical volumes did not
mount.  A quick search and I found that /dev/vg0/lvol0 was missing
from the /dev tree.  However, they logical volume seems to be intact
from the output of LVM.  I found what appears to be an issue that
device-mapper is running into on boot:

Current Software:
Linux 2.6.18-238.12.1.el5 #1 SMP Tue May 31 13:23:01 EDT 2011 i686
i686 i386 GNU/Linux
device-mapper-1.02.55-2.el5

Kernel Messages:
device-mapper: multipath: version 1.0.6 loaded
device-mapper: table: 253:4: linear: dm-linear: Device lookup failed
device-mapper: ioctl: error adding target to table


I did some research and the only info I could find was regarding dmsetup:

#dmsetup status
pdc_eehgddjjp1: 0 976768002 linear
pdc_eehgddjj: 0 976772992 linear
via_cdeadaheebp1: 0 976768002 linear
via_cdeadaheeb: 0 1953546240 striped 2 8:0 8:16 1 AA


Looks like something is wrong with the vg0-lvol0 entry above, but I
can't figure out how to fix it.  There is also another HDD on each of
the via and pdc controllers that are seen by the system, but not
showing up in the "status" list above.  There is also a disk connected
to PATA port "/dev/hda" that is part of the lvol.

The device-mapper device is being created for the lvol:

 /dev/mapper/vg0-lvol0


David

-- 
David Cramblett
