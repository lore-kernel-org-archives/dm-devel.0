From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: RE: Problem with multipathd and a blacklisted device
Date: Tue, 31 Mar 2009 10:49:57 -0500
Message-ID: <20090331154957.GM15911@ether.msp.redhat.com>
References: <5635940A0F6F36478CF4D01273B16CA32B9C3EDDF8@GVW1096EXB.americas.hpqcorp.net>
	<5635940A0F6F36478CF4D01273B16CA32B9CE52C1E@GVW1096EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5635940A0F6F36478CF4D01273B16CA32B9CE52C1E@GVW1096EXB.americas.hpqcorp.net>
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

> > This configuration works well until I do some failure testing
> > with one of the 2 blacklisted devs in the software RAID set.
> > I found that if I temporarily remove disk sda and put it back
> > a minute later the disk path, /dev/hpdev/sda1, is removed,
> > even though it is blacklisted.

multipathd shouldn't be removing and devices.  It removes paths from is
list of monitored paths, but not from the filesystem.  Try doing this
without multipathd running, and see if the device still disappears.

That all being said, multipathd shouldn't be monitoring the device
if it's backlisted.  Did you start up multipathd before you blacklisted
the device?  If so, you need to run

# service multipathd reload

To make multipathd pick up the new configuration. Or you can simply
restart it. You can check to see if it is monitoring the paths
by running

# multipathd -k"show paths"

-Ben

> >
> > Here are some of the pertinent /var/log/messages lines:
> >
> > Mar 19 09:53:19 n0 mdadm: NewArray /dev/md0 Mar 19 10:05:12
> > n0 kernel: mptbase: ioc0: LogInfo(0x31170000):
> > Originator={PL}, Code={IO Device Missing Delay Retry},
> > SubCode(0x0000) Mar 19 10:05:40 n0 last message repeated 5
> > times Mar 19 10:05:42 n0 kernel: mptbase: ioc0:
> > LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet
> > Executed}, SubCode(0x0000) Mar 19 10:05:42 n0 kernel: sd
> > 0:0:28:0: SCSI error: return code = 0x00010000 Mar 19
> > 10:05:42 n0 kernel: end_request: I/O error, dev sda, sector
> > 256119 Mar 19 10:05:42 n0 kernel: Buffer I/O error on device
> > sda1, logical block 256056 Mar 19 10:05:42 n0 kernel: Buffer
> > I/O error on device sda1, logical block 256057 Mar 19
> > 10:05:42 n0 kernel: Buffer I/O error on device sda1, logical
> > block 256058 Mar 19 10:05:42 n0 kernel: Buffer I/O error on
> > device sda1, logical block 256059 Mar 19 10:05:42 n0 kernel:
> > Buffer I/O error on device sda1, logical block 256060 Mar 19
> > 10:05:42 n0 kernel: Buffer I/O error on device sda1, logical
> > block 256061 Mar 19 10:05:42 n0 kernel: mptbase: ioc0:
> > LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet
> > Executed}, SubCode(0x0000) Mar 19 10:05:42 n0 kernel: Buffer
> > I/O error on device sda1, logical block 256062 Mar 19
> > 10:05:42 n0 kernel: Buffer I/O error on device sda1, logical
> > block 256063 Mar 19 10:05:42 n0 kernel: sd 0:0:28:0: SCSI
> > error: return code = 0x00010000 Mar 19 10:05:42 n0
> > multipathd: sda: remove path (uevent) Mar 19 10:05:42 n0
> > kernel: end_request: I/O error, dev sda, sector 585922495 Mar
> > 19 10:05:42 n0 kernel: Buffer I/O error on device sda1,
> > logical block 585922432 Mar 19 10:05:42 n0 xinetd[13096]:
> > START: hacl-cfgudp pid=6034 from=127.0.0.1 Mar 19 10:05:42 n0
> > multipathd: uevent trigger error Mar 19 10:05:42 n0 kernel:
> > Buffer I/O error on device sda1, logical block 585922433
> >
> >
> > The sda path is gone:
> >
> > /root> ls -l /dev/hpdev
> > total 0
> > lrwxrwxrwx 1 root root 7 Mar 18 03:32 sdb1 -> ../sdb1 /root>
> >
> > And I cannot reassemble the software raid set.  While the
> > mdstat looks 'normal' the software raid becomes degraded.
> >
> > /etc/udev/rules.d> cat /proc/mdstat
> > Personalities : [raid1]
> > md0 : active raid1 sda1[2](F) sdb1[1]
> >       292961216 blocks [2/1] [_U]
> >
> > unused devices: <none>
> > /etc/udev/rules.d> mdadm --detail /dev/md0
> > /dev/md0:
> >         Version : 00.90.03
> >   Creation Time : Wed Feb 18 14:15:03 2009
> >      Raid Level : raid1
> >      Array Size : 292961216 (279.39 GiB 299.99 GB)
> >     Device Size : 292961216 (279.39 GiB 299.99 GB)
> >    Raid Devices : 2
> >   Total Devices : 2
> > Preferred Minor : 0
> >     Persistence : Superblock is persistent
> >
> >     Update Time : Thu Mar 19 10:28:45 2009
> >           State : clean, degraded
> >  Active Devices : 1
> > Working Devices : 1
> >  Failed Devices : 1
> >   Spare Devices : 0
> >
> >            UUID : 94813396:a3e341fc:c5d4b8ba:0617a019
> >          Events : 0.86
> >
> >     Number   Major   Minor   RaidDevice State
> >        0       0        0        0      removed
> >        1       8       17        1      active sync   /dev/sdb1
> >
> >        2       8        1        -      faulty spare
> > /etc/udev/rules.d>
> >
> > The disk is fine and is back in and ready to go.
> >
> > So, 1) why does multipathd remove the path for a blacklisted
> > device?  If it is blacklisted, shouldn't multipathd just
> > leave it alone??
> > And 2) what can I do to keep this from happening??
> >
> > Lori Ransegnola
> >
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
